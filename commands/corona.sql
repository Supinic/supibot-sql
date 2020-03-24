INSERT INTO
	`chat_data`.`Command`
	(
		ID,
		Name,
		Aliases,
		Description,
		Cooldown,
		Rollbackable,
		System,
		Skip_Banphrases,
		Whitelisted,
		Whitelist_Response,
		Read_Only,
		Opt_Outable,
		Blockable,
		Ping,
		Pipeable,
		Archived,
		Static_Data,
		Code,
		Examples,
		Dynamic_Description
	)
VALUES
	(
		200,
		'corona',
		NULL,
		'Checks the current amount of infected/deceased people from the Corona Virus spread started in October-December 2019.',
		7500,
		0,
		0,
		0,
		0,
		NULL,
		0,
		0,
		0,
		1,
		1,
		0,
		'(() => {
	const baseURL = \"https://worldometers.info/coronavirus/\";
	const regions = [
		\"Africa\",
		\"Antarctica\",
		\"Asia\",
		\"Central America\",
		\"Europe\",
		\"North America\",
		\"Oceania\",
		\"South America\"
	].map(i => i.toLowerCase());
	const special = {
		\"CAR\": \"Central African Republic\",
		\"DRC\": \"Democratic Republic of the Congo\",
		\"UAE\": \"United Arab Emirates\",
		\"UK\": \"United Kingdom\",
		\"USA\": \"United States of America\"
	};
	const handlers = {
		\"fetch-fail\": {
			reply: \"The data source website is currently under down! Try again later (at least 1 minute),\",
			cooldown: {
				user: null,
				channel: null,
				length: 60000
			}
		},
		\"no-rows\": {
			reply: \"The data source website is currently under heavy load! Try again later (at least 15s).\",
			cooldown: {
				user: null,
				channel: null,
				length: 15000
			}
		},
	};

	return {
		baseURL,
		handlers,
		regions,
		special,

		fetchData: async (options = {}) => {
			let html = null;
			try {
				html = await sb.Got.instances.FakeAgent({
					prefixUrl: baseURL,
					url: options.url
				}).text();
			}
			catch (e) {
				return {
					success: false,
					cause: \"fetch-fail\",
					exception: e
				}
			}

			const $ = sb.Utils.cheerio(html);
			const rows = Array.from($(options.selector));
			if (rows.length === 0) {
				return {
					success: false,
					cause: \"no-rows\"
				}
			}

			const total = {};
			for (const field of options.fields) {
				if (field === \"country\") {
					total.country = \"Total\";
					total.region = options.region;
				}
				else {
					total[field] = 0;
				}
			}

			const result = [];
			for (const row of rows) {
				const values = Array.from($(row).children()).map((node, ind) => {
					let value = null;
					const selector = $(node);

					if (ind !== 0) {
						value = Number(selector.text().replace(/,/g, \"\")) || 0;
					}
					else {
						const country = selector.text();
						value = {
							country,
							link: (node.firstChild?.tagName === \"a\")
								? `${baseURL}${node.firstChild.attribs.href}`
								: null
						};
					}

					return value;
				});
				
				if (values[0].country.toLowerCase().includes(\"total\")) {
					continue;
				}

				const rowObject = { 
					region: options.region ?? null
				};

				for (let i = 0; i < options.fields.length; i++) {
					const field = options.fields[i];
					let value = values[i];

					if (field === \"country\") {
						let { country, link } = value;
						country = country.trim();

						// Fixing special cases
						if (country === \"S. Korea\") {
							country = \"South Korea\";
						}

						// Fixing \"U.A.E.\" and \"U.K.\"
						country = country.replace(/\\./g, \"\");
						rowObject.country = country;
						rowObject.link = link;
					}
					else {
						total[field] += value;
						rowObject[field] = value;
					}
				}

				result.push(rowObject);
			}

			result.push({
				total: true,
				...total
			});
			
			return {
				success: true,
				rows: result,
				selector: $
			};
		}
	};
})()',
		'(async function corona (context, ...args) {
	if (this.data.fetching) {
		return {
			reply: \"Someone else is currently fetching the data. Try again in a moment.\"
		};
	}
	else if (!this.data.cache || sb.Date.now() > this.data.nextReload) {
		if (context.channel) {
			sb.Master.send(`${context.user.Name}, Fetching new data! ppHop`, context.channel);
		}
		else {
			sb.Master.pm(context.user.Name, \"Fetching new data! ppHop\", context.platform);
		}

		this.data.fetching = true;

		const [mainData, usaData] = await Promise.all([
			this.staticData.fetchData({
				url: \"\",
				region: null,
				selector: \"#main_table_countries_today tbody tr\",
				fields: [\"country\", \"confirmed\", \"newCases\", \"deaths\", \"newDeaths\", \"recovered\", \"active\", \"critical\", \"cpm\", \"dpm\"]
			}),
			this.staticData.fetchData({
				url: \"country/us\",
				region: \"USA\",
				selector: \"#usa_table_countries_today tbody tr\",
				fields: [\"country\", \"confirmed\", \"newCases\", \"deaths\", \"newDeaths\"]
			})
		]);

		this.data.fetching = false;

		if (!mainData.success || !usaData.success) {
			const { reply, cooldown } = this.staticData.handlers[mainData.cause || usaData.cause];
			return { reply, cooldown };
		}

		this.data.cache = [mainData.rows, usaData.rows].flat();
		this.data.countries = new Set(this.data.cache.filter(i => i.country).map(i => i.country));

		const lastUpdateString = mainData.selector(\".label-counter\").next().text().replace(\"Last updated \", \"\");
		this.data.update = new sb.Date(lastUpdateString);
		this.data.nextReload = new sb.Date().addMinutes(15).valueOf();
	}

	let targetData = null;
	const input = args.join(\" \").toLowerCase();

	if (this.staticData.regions.includes(input)) {
		const special = Object.values(this.staticData.special).map(i => i.toLowerCase());
		const eligibleCountries = (await sb.Query.getRecordset(rs => rs
			.select(\"Name\")
			.from(\"data\", \"Country\")
			.where(\"Region = %s\", input)
		)).map(i => i.Name.toLowerCase());

		const eligibleData = this.data.cache.filter(i => (
			eligibleCountries.includes(i.country.toLowerCase())
			|| eligibleCountries.includes((this.staticData.special[i.country] || \"\").toLowerCase())
		));

		targetData = {
			confirmed: 0,
			deaths: 0,
			newCases: 0,
			newDeaths: 0,
			recovered: 0
		};

		for (const record of eligibleData) {
			for (const key of Object.keys(targetData)) {
				targetData[key] += record[key];
			}
		}

		targetData.country = args.join(\" \");
	}
	else if (args.length > 0) {
		const bestMatch = sb.Utils.selectClosestString(
			input,
			Array.from(this.data.countries),
			{ ignoreCase: true }
		);

		targetData = this.data.cache.find(i => i.country.toLowerCase() === bestMatch);
	}
	else {
		this.data.cache.find(i => i.country === \"Total\" && i.region == null);
	}

	if (targetData) {
		const delta = sb.Utils.timeDelta(new sb.Date(this.data.update));
		const {
			confirmed,
			country,
			cpm,
			critical,
			dpm,
			deaths,
			link,
			newCases,
			newDeaths,
			recovered
		} = targetData;

		if (args.length > 0) {
			let region = targetData.region ?? \"\";
			const fixedCountryName = this.staticData.special[country] ?? country;
			const countryData = await sb.Query.getRecordset(rs => rs
				.select(\"Code_Alpha_2 AS Code\")
				.from(\"data\", \"Country\")
				.where(\"Name = %s\", fixedCountryName)
				.limit(1)
				.single()
			);

			let emoji = country;
			if (region === \"USA\") {
				region = \" (🇺🇸)\";
			}
			else if (countryData?.Code) {
				emoji = String.fromCodePoint(...countryData.Code.split(\"\").map(i => i.charCodeAt(0) + 127397));
			}

			const linkString = (link) ? `More info: ${link}` : \"\";
			const plusCases = (newCases > 0) ? ` (+${newCases})` : \"\";
			const plusDeaths = (newDeaths > 0) ? ` (+${newDeaths})` : \"\";
			const million = [];
			if (cpm > 0) {
				million.push(`${cpm} cases`);
			}
			if (dpm > 0) {
				million.push(`${dpm} deaths`);
			}

			const perMillion = (million.length > 0)
				? `This is ${million.join(\" and \")} per million. `
				: \"\";

			return {
				reply: `${emoji ?? country}${region} has ${confirmed} confirmed case${(confirmed === 1) ? \"\" : \"s\"}${plusCases}, ${deaths ?? \"no\"} death${(deaths === 1) ? \"\" : \"s\"}${plusDeaths} and ${recovered ?? \"no\"} recovered case${(recovered === 1) ? \"\" : \"s\"}. ${perMillion}${linkString}`
			}
		}
		else {
			const emoji = sb.Utils.randArray([\"🌏\", \"🌎\", \"🌍\"]);
			return {
				reply: `${emoji} ${confirmed} (+${newCases}) corona virus cases are tracked so far. ${mild} are in mild, and ${critical} in critical condition; ${recovered} have fully recovered, and there are ${deaths} (+${newDeaths}) deceased. Last check: ${delta}.`
			}
		}
	}
	else {
		return {
			reply: \"That country has no Corona virus data available.\"
		};
	}
})',
		NULL,
		'async (prefix) => {
	const row = await sb.Query.getRow(\"chat_data\", \"Command\");
	await row.load(200);

	const data = eval(row.values.Static_Data);
	const regions = data.regions.map(i => `<code>${i}</code>`);


	return [
		`Checks the latest data on the Corona COVID-19 virus\'s spread.`,

		`<code>${prefix}corona</code>`,
		\"Posts global data.\",
		\"\",

		`<code>${prefix}corona (country)</code>`,
		`Posts given country\'s data. If the country is not found, or it has no cases, it will say \"no data available\".`,
		``,

		`<code>${prefix}corona (region)</code>`,
		\"Posts data for a given global region. Supported regions:\",
		regions.join(\"<br>\")
	];
}'
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function corona (context, ...args) {
	if (this.data.fetching) {
		return {
			reply: \"Someone else is currently fetching the data. Try again in a moment.\"
		};
	}
	else if (!this.data.cache || sb.Date.now() > this.data.nextReload) {
		if (context.channel) {
			sb.Master.send(`${context.user.Name}, Fetching new data! ppHop`, context.channel);
		}
		else {
			sb.Master.pm(context.user.Name, \"Fetching new data! ppHop\", context.platform);
		}

		this.data.fetching = true;

		const [mainData, usaData] = await Promise.all([
			this.staticData.fetchData({
				url: \"\",
				region: null,
				selector: \"#main_table_countries_today tbody tr\",
				fields: [\"country\", \"confirmed\", \"newCases\", \"deaths\", \"newDeaths\", \"recovered\", \"active\", \"critical\", \"cpm\", \"dpm\"]
			}),
			this.staticData.fetchData({
				url: \"country/us\",
				region: \"USA\",
				selector: \"#usa_table_countries_today tbody tr\",
				fields: [\"country\", \"confirmed\", \"newCases\", \"deaths\", \"newDeaths\"]
			})
		]);

		this.data.fetching = false;

		if (!mainData.success || !usaData.success) {
			const { reply, cooldown } = this.staticData.handlers[mainData.cause || usaData.cause];
			return { reply, cooldown };
		}

		this.data.cache = [mainData.rows, usaData.rows].flat();
		this.data.countries = new Set(this.data.cache.filter(i => i.country).map(i => i.country));

		const lastUpdateString = mainData.selector(\".label-counter\").next().text().replace(\"Last updated \", \"\");
		this.data.update = new sb.Date(lastUpdateString);
		this.data.nextReload = new sb.Date().addMinutes(15).valueOf();
	}

	let targetData = null;
	const input = args.join(\" \").toLowerCase();

	if (this.staticData.regions.includes(input)) {
		const special = Object.values(this.staticData.special).map(i => i.toLowerCase());
		const eligibleCountries = (await sb.Query.getRecordset(rs => rs
			.select(\"Name\")
			.from(\"data\", \"Country\")
			.where(\"Region = %s\", input)
		)).map(i => i.Name.toLowerCase());

		const eligibleData = this.data.cache.filter(i => (
			eligibleCountries.includes(i.country.toLowerCase())
			|| eligibleCountries.includes((this.staticData.special[i.country] || \"\").toLowerCase())
		));

		targetData = {
			confirmed: 0,
			deaths: 0,
			newCases: 0,
			newDeaths: 0,
			recovered: 0
		};

		for (const record of eligibleData) {
			for (const key of Object.keys(targetData)) {
				targetData[key] += record[key];
			}
		}

		targetData.country = args.join(\" \");
	}
	else if (args.length > 0) {
		const bestMatch = sb.Utils.selectClosestString(
			input,
			Array.from(this.data.countries),
			{ ignoreCase: true }
		);

		targetData = this.data.cache.find(i => i.country.toLowerCase() === bestMatch);
	}
	else {
		this.data.cache.find(i => i.country === \"Total\" && i.region == null);
	}

	if (targetData) {
		const delta = sb.Utils.timeDelta(new sb.Date(this.data.update));
		const {
			confirmed,
			country,
			cpm,
			critical,
			dpm,
			deaths,
			link,
			newCases,
			newDeaths,
			recovered
		} = targetData;

		if (args.length > 0) {
			let region = targetData.region ?? \"\";
			const fixedCountryName = this.staticData.special[country] ?? country;
			const countryData = await sb.Query.getRecordset(rs => rs
				.select(\"Code_Alpha_2 AS Code\")
				.from(\"data\", \"Country\")
				.where(\"Name = %s\", fixedCountryName)
				.limit(1)
				.single()
			);

			let emoji = country;
			if (region === \"USA\") {
				region = \" (🇺🇸)\";
			}
			else if (countryData?.Code) {
				emoji = String.fromCodePoint(...countryData.Code.split(\"\").map(i => i.charCodeAt(0) + 127397));
			}

			const linkString = (link) ? `More info: ${link}` : \"\";
			const plusCases = (newCases > 0) ? ` (+${newCases})` : \"\";
			const plusDeaths = (newDeaths > 0) ? ` (+${newDeaths})` : \"\";
			const million = [];
			if (cpm > 0) {
				million.push(`${cpm} cases`);
			}
			if (dpm > 0) {
				million.push(`${dpm} deaths`);
			}

			const perMillion = (million.length > 0)
				? `This is ${million.join(\" and \")} per million. `
				: \"\";

			return {
				reply: `${emoji ?? country}${region} has ${confirmed} confirmed case${(confirmed === 1) ? \"\" : \"s\"}${plusCases}, ${deaths ?? \"no\"} death${(deaths === 1) ? \"\" : \"s\"}${plusDeaths} and ${recovered ?? \"no\"} recovered case${(recovered === 1) ? \"\" : \"s\"}. ${perMillion}${linkString}`
			}
		}
		else {
			const emoji = sb.Utils.randArray([\"🌏\", \"🌎\", \"🌍\"]);
			return {
				reply: `${emoji} ${confirmed} (+${newCases}) corona virus cases are tracked so far. ${mild} are in mild, and ${critical} in critical condition; ${recovered} have fully recovered, and there are ${deaths} (+${newDeaths}) deceased. Last check: ${delta}.`
			}
		}
	}
	else {
		return {
			reply: \"That country has no Corona virus data available.\"
		};
	}
})'