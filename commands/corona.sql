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
		'({
	special: {
		\"CAR\": \"Central African Republic\",
		\"DRC\": \"Democratic Republic of the Congo\",
		\"UAE\": \"United Arab Emirates\",
		\"UK\": \"United Kingdom\",
		\"USA\": \"United States of America\"
	},
	regions: [
		\"Africa\", 
		\"Antarctica\", 
		\"Asia\", 
		\"Central America\", 
		\"Europe\", 
		\"North America\", 
		\"Oceania\", 
		\"South America\"
	].map(i => i.toLowerCase())
})',
		'(async function corona (context, ...args) {
	if (this.data.fetching) {
		return {
			reply: \"Someone else is currently fetching the data. Try again in a moment.\"
		};
	}

	if (!this.data.cache || sb.Date.now() > this.data.nextReload) {
		if (context.channel) {
			sb.Master.send(`${context.user.Name}, Fetching new data! ppHop`, context.channel);
		}
		else {
			sb.Master.pm(context.user.Name, \"Fetching new data! ppHop\", context.platform);
		}

		this.data.fetching = true;

		let html = null;
		try {
			html = await sb.Got.instances.FakeAgent(\"https://www.worldometers.info/coronavirus/\").text();
		}
		catch (e) {
			console.warn(\"Corona site dead?\", e);
			this.data.fetching = false;
			return {
				reply: \"The data source website is currently under down! Try again later (at least 1 minute).\",
				cooldown: {
					user: null,
					channel: null,
					length: 60000
				}
			};
		}

		const $ = sb.Utils.cheerio(html);
		const rows = Array.from($(\"#main_table_countries_today tbody tr\"));

		if (rows.length === 0) {
			this.data.fetching = false;
			return {
				reply: \"The data source website is currently under heavy load! Try again later (at least 15s).\",
				cooldown: {
					user: null,
					channel: null,
					length: 15000
				}
			};
		}

		let totalNewCases = 0;
		let totalNewDeaths = 0;

		this.data.countries = [];
		this.data.cache = [];
		for (const row of rows) {
			let [country, confirmed, newCases, deaths, newDeaths, recovered, active, critical, cpm] = Array.from($(row).children()).map((i, ind) => {
				let value = $(i).text();
				if (ind !== 0) {
					value = Number(value.replace(/,/g, \"\")) || 0;
				}

				return value;
			});

			country = country.trim();

			// Making sure totals aren\'t counted in again
			if (country.toLowerCase().includes(\"total\")) {
				continue;
			}

			// Fixing special cases
			if (country === \"S. Korea\") {
				country = \"South Korea\";
			}
			// Fixing \"U.A.E.\" and \"U.K.\"
			country = country.replace(/\\./g, \"\");

			this.data.countries.push(country);

			totalNewCases += newCases;
			totalNewDeaths += newDeaths;

			this.data.cache.push({
				country,
				confirmed,
				newCases,
				deaths,
				newDeaths,
				recovered,
				critical,
				active,
				cpm
			});
		}

		const [confirmed, deaths, recovered] = $(\".maincounter-number\").text().replace(/,/g, \"\").replace(/\\s+/g, \" \").split(\" \").filter(Boolean).map(Number);
		const [mild, critical] = Array.from($(\".number-table\")).map(i => Number(i.firstChild.nodeValue.replace(/,/g, \"\")));
		const lastUpdateString = $(\".label-counter\").next().text().replace(\"Last updated \", \"\");

		this.data.update = new sb.Date(lastUpdateString);
		this.data.total = { confirmed, deaths, recovered, critical, mild, newCases: totalNewCases, newDeaths: totalNewDeaths };

		this.data.pastebinLink = null;
		this.data.nextReload = new sb.Date().addMinutes(15).valueOf();

		this.data.fetching = false;
	}

	if (args[0] === \"dump\" || args[0] === \"json\") {
		if (!this.data.pastebinLink) {
			this.data.pastebinLink = await sb.Pastebin.post(JSON.stringify(this.data, null, 4), { format: \"json\" });
		}

		return {
			reply: this.data.pastebinLink
		};
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
	else {
		const bestMatch = sb.Utils.selectClosestString(input, this.data.countries, {
			ignoreCase: true
		});

		targetData = (args.length > 0)
			? this.data.cache.find(i => i.country.toLowerCase() === bestMatch)
			: this.data.total;
	}

	if (targetData) {
		const delta = sb.Utils.timeDelta(new sb.Date(this.data.update));
		const { confirmed, deaths, newCases, newDeaths, recovered, country, critical, mild, cpm } = targetData;

		if (args.length > 0) {
			const fixedCountryName = this.staticData.special[country] ?? country;
			const countryData = await sb.Query.getRecordset(rs => rs
				.select(\"Code_Alpha_2 AS Code\")
				.from(\"data\", \"Country\")
				.where(\"Name = %s\", fixedCountryName)
				.limit(1)
				.single()
			);

			const emoji = (countryData?.Code)
				? String.fromCodePoint(...countryData.Code.split(\"\").map(i => i.charCodeAt(0) + 127397))
				: country;

			const plusCases = (newCases > 0) ? ` (+${newCases})` : \"\";
			const plusDeaths = (newDeaths > 0) ? ` (+${newDeaths})` : \"\";
			const perMillion = (cpm > 0) ? `This is ${cpm} cases per 1 million people. ` : \"\";

			return {
				reply: `${emoji ?? country} has ${confirmed} confirmed case${(confirmed === 1) ? \"\" : \"s\"}${plusCases}, ${deaths ?? \"no\"} death${(deaths === 1) ? \"\" : \"s\"}${plusDeaths} and ${recovered ?? \"no\"} recovered case${(recovered === 1) ? \"\" : \"s\"}. ${perMillion}Last check: ${delta}.`
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

	if (!this.data.cache || sb.Date.now() > this.data.nextReload) {
		if (context.channel) {
			sb.Master.send(`${context.user.Name}, Fetching new data! ppHop`, context.channel);
		}
		else {
			sb.Master.pm(context.user.Name, \"Fetching new data! ppHop\", context.platform);
		}

		this.data.fetching = true;

		let html = null;
		try {
			html = await sb.Got.instances.FakeAgent(\"https://www.worldometers.info/coronavirus/\").text();
		}
		catch (e) {
			console.warn(\"Corona site dead?\", e);
			this.data.fetching = false;
			return {
				reply: \"The data source website is currently under down! Try again later (at least 1 minute).\",
				cooldown: {
					user: null,
					channel: null,
					length: 60000
				}
			};
		}

		const $ = sb.Utils.cheerio(html);
		const rows = Array.from($(\"#main_table_countries_today tbody tr\"));

		if (rows.length === 0) {
			this.data.fetching = false;
			return {
				reply: \"The data source website is currently under heavy load! Try again later (at least 15s).\",
				cooldown: {
					user: null,
					channel: null,
					length: 15000
				}
			};
		}

		let totalNewCases = 0;
		let totalNewDeaths = 0;

		this.data.countries = [];
		this.data.cache = [];
		for (const row of rows) {
			let [country, confirmed, newCases, deaths, newDeaths, recovered, active, critical, cpm] = Array.from($(row).children()).map((i, ind) => {
				let value = $(i).text();
				if (ind !== 0) {
					value = Number(value.replace(/,/g, \"\")) || 0;
				}

				return value;
			});

			country = country.trim();

			// Making sure totals aren\'t counted in again
			if (country.toLowerCase().includes(\"total\")) {
				continue;
			}

			// Fixing special cases
			if (country === \"S. Korea\") {
				country = \"South Korea\";
			}
			// Fixing \"U.A.E.\" and \"U.K.\"
			country = country.replace(/\\./g, \"\");

			this.data.countries.push(country);

			totalNewCases += newCases;
			totalNewDeaths += newDeaths;

			this.data.cache.push({
				country,
				confirmed,
				newCases,
				deaths,
				newDeaths,
				recovered,
				critical,
				active,
				cpm
			});
		}

		const [confirmed, deaths, recovered] = $(\".maincounter-number\").text().replace(/,/g, \"\").replace(/\\s+/g, \" \").split(\" \").filter(Boolean).map(Number);
		const [mild, critical] = Array.from($(\".number-table\")).map(i => Number(i.firstChild.nodeValue.replace(/,/g, \"\")));
		const lastUpdateString = $(\".label-counter\").next().text().replace(\"Last updated \", \"\");

		this.data.update = new sb.Date(lastUpdateString);
		this.data.total = { confirmed, deaths, recovered, critical, mild, newCases: totalNewCases, newDeaths: totalNewDeaths };

		this.data.pastebinLink = null;
		this.data.nextReload = new sb.Date().addMinutes(15).valueOf();

		this.data.fetching = false;
	}

	if (args[0] === \"dump\" || args[0] === \"json\") {
		if (!this.data.pastebinLink) {
			this.data.pastebinLink = await sb.Pastebin.post(JSON.stringify(this.data, null, 4), { format: \"json\" });
		}

		return {
			reply: this.data.pastebinLink
		};
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
	else {
		const bestMatch = sb.Utils.selectClosestString(input, this.data.countries, {
			ignoreCase: true
		});

		targetData = (args.length > 0)
			? this.data.cache.find(i => i.country.toLowerCase() === bestMatch)
			: this.data.total;
	}

	if (targetData) {
		const delta = sb.Utils.timeDelta(new sb.Date(this.data.update));
		const { confirmed, deaths, newCases, newDeaths, recovered, country, critical, mild, cpm } = targetData;

		if (args.length > 0) {
			const fixedCountryName = this.staticData.special[country] ?? country;
			const countryData = await sb.Query.getRecordset(rs => rs
				.select(\"Code_Alpha_2 AS Code\")
				.from(\"data\", \"Country\")
				.where(\"Name = %s\", fixedCountryName)
				.limit(1)
				.single()
			);

			const emoji = (countryData?.Code)
				? String.fromCodePoint(...countryData.Code.split(\"\").map(i => i.charCodeAt(0) + 127397))
				: country;

			const plusCases = (newCases > 0) ? ` (+${newCases})` : \"\";
			const plusDeaths = (newDeaths > 0) ? ` (+${newDeaths})` : \"\";
			const perMillion = (cpm > 0) ? `This is ${cpm} cases per 1 million people. ` : \"\";

			return {
				reply: `${emoji ?? country} has ${confirmed} confirmed case${(confirmed === 1) ? \"\" : \"s\"}${plusCases}, ${deaths ?? \"no\"} death${(deaths === 1) ? \"\" : \"s\"}${plusDeaths} and ${recovered ?? \"no\"} recovered case${(recovered === 1) ? \"\" : \"s\"}. ${perMillion}Last check: ${delta}.`
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