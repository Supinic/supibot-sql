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
	const special = {
		\"CAR\": \"Central African Republic\",
		\"DRC\": \"Democratic Republic of the Congo\",
		\"UAE\": \"United Arab Emirates\",
		\"UK\": \"United Kingdom\",
		\"USA\": \"United States of America\"
	};
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

	return {
		special,
		regions,
		fetch: {
			topData: (limit) => sb.Query.getRecordset(rs => rs
				.select(\"Place.Name AS Country\", \"All_Cases\")
				.from(\"corona\", \"Status\")
				.join({
					toTable: \"Place\",
					on: \"Place.ID = Status.Place\"
				})
				.where(\"Place.Parent IS NULL\")
				.groupBy(\"Place\")
				.orderBy(\"Date DESC\")
				.orderBy(\"All_Cases DESC\")
				.limit(limit)
			),
			regionalData: (region) => sb.Query.getRecordset(rs => rs
				.select(\"Place.Name\")
				.select(\"Place.Parent\")
				.select(\"Place.Region\")
				.select(\"All_Cases\")
				.select(\"All_Deaths\")
				.select(\"All_Recoveries\")
				.select(\"New_Cases\")
				.select(\"New_Deaths\")
				.from(\"corona\", \"Status\")
				.join({
					toTable: \"Place\",
					on: \"Place.ID = Status.Place\"
				})
				.where({ condition: region === null }, \"Place.Parent IS NULL\")
				.where({ condition: typeof region === \"string\" }, \"Place.Region = %s\", region)
				.groupBy(\"Status.Place\")
				.orderBy(\"Status.Date DESC\")
			),
			countryData: (region, country, direct = false) => sb.Query.getRecordset(rs => rs
				.select(\"Place.Name\")
				.select(\"Place.Parent\")
				.select(\"All_Cases\")
				.select(\"All_Deaths\")
				.select(\"All_Recoveries\")
				.select(\"New_Cases\")
				.select(\"New_Deaths\")
				.from(\"corona\", \"Status\")
				.join({
					toTable: \"Place\",
					on: \"Place.ID = Status.Place\"
				})
				.where({ condition: direct === false }, \"Place.Name %*like*\", country)
				.where({ condition: direct === true }, \"Place.Name = %s\", country)
				.where({ condition: region !== null }, \"Place.Parent = %s\", region)
				.orderBy(\"Status.Date DESC\")
				.limit(1)
			)
		},
		sumObjectArray: (array) => {
			const result = {};
			for (const row of array) {
				for (const key of Object.keys(row)) {
					if (typeof row[key] === \"number\") {
						result[key] = (result[key] ?? 0) + row[key];
					}
				}
			}

			return result;
		},
		getEmoji: async (country) => {
			if (country === null) {
				return sb.Utils.randArray([\"🌏\", \"🌎\", \"🌍\"]);
			}

			const fixedCountryName = special[country.toUpperCase()] ?? country;
			const countryData = await sb.Query.getRecordset(rs => rs
				.select(\"Code_Alpha_2 AS Code\")
				.from(\"data\", \"Country\")
				.where(\"Name = %s\", fixedCountryName)
				.limit(1)
				.single()
			);

			if (countryData?.Code) {
				return String.fromCodePoint(...countryData.Code.split(\"\").map(i => i.charCodeAt(0) + 127397));
			}
			else {
				return null;
			}
		}
	};
})()',
		'(async function corona (context, ...args) {
	const input = args.join(\" \").toLowerCase();
	let region = null;
	let country = null;
	let targetData = null;

	if (input.startsWith(\"@\")) {
		const userData = await sb.User.get(input);
		if (!userData) {
			return {
				success: false,
				reply: \"That user does not exist!\"
			};
		}
		else if (!userData.Data.location) {
			return {
				success: false,
				reply: \"That user does not have their location set!\"
			};
		}
		else if (userData.Data.location.hidden) {
			return {
				success: false,
				reply: \"That user has hidden their precise location!\"
			};
		}
		else if (!userData.Data.location.components.country) {
			return {
				success: false,
				reply: \"That user does not have their country location set!\"
			};
		}

		country = userData.Data.location.components.country;
	}

	if (input === \"top\") {
		const result = (await this.staticData.fetch.topData(10))
			.map((i, ind) => `#${ind + 1}: ${i.Country} (${i.All_Cases})`)
			.join(\"; \");

		return {
			reply: \"Top 10 countries by cases: \" + result
		};
	}
	else if (input.includes(\":\")) {
		[region, country] = input.split(\":\").map(i => i.trim());
	}
	else if (input.length > 0) {
		country = input;
	}

	if (this.staticData.regions.includes(input)) {
		region = input;
		targetData = await this.staticData.fetch.regionalData(region);
	}
	else if (country) {
		const [loose, strict] = await Promise.all([
			this.staticData.fetch.countryData(region, country, false),
			this.staticData.fetch.countryData(region, country, true)
		]);

		const result = sb.Utils.selectClosestString(
			country,
			[loose[0]?.Name, strict[0]?.Name].filter(Boolean),
			{ ignoreCase: true }
		);

		targetData = [loose, strict].find(i => i[0]?.Name && i[0].Name.toLowerCase() === result.toLowerCase());
	}
	else {
		targetData = await this.staticData.fetch.regionalData(null);
	}

	if (!targetData || targetData.length === 0) {
		return {
			reply: \"That country has no Corona virus data available!\"
		};
	}
	
	const { Region: prettyRegion } = targetData[0];
	if (targetData.length === 1) {
		targetData = targetData[0];
	}
	else if (targetData.length > 1) {
		targetData = this.staticData.sumObjectArray(targetData);
	}

	let intro = null;
	if (region) {
		intro = prettyRegion;
	}
	else if (!targetData.Parent) {
		intro = await this.staticData.getEmoji(targetData.Name ?? null);
		if (!intro) {
			intro = targetData.Name;
		}
	}
	else {
		const emoji = await this.staticData.getEmoji(targetData.Parent);
		intro = `${targetData.Name} (${emoji})`;
	}

	const {
		All_Cases: allCases,
		All_Deaths: allDeaths,
		All_Recoveries: allRecoveries,
		New_Cases: newCases,
		New_Deaths: newDeaths,
	} = targetData;

	const plusCases = (newCases > 0) ? ` (+${newCases})` : \"\";
	const plusDeaths = (newDeaths > 0) ? ` (+${newDeaths})` : \"\";
	return {
		reply: `${intro} has ${allCases} confirmed case${(allCases === 1) ? \"\" : \"s\"}${plusCases}, ${allDeaths ?? \"no\"} death${(allDeaths === 1) ? \"\" : \"s\"}${plusDeaths} and ${allRecoveries ?? \"no\"} recovered case${(allRecoveries === 1) ? \"\" : \"s\"}.`
	};
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
	const input = args.join(\" \").toLowerCase();
	let region = null;
	let country = null;
	let targetData = null;

	if (input.startsWith(\"@\")) {
		const userData = await sb.User.get(input);
		if (!userData) {
			return {
				success: false,
				reply: \"That user does not exist!\"
			};
		}
		else if (!userData.Data.location) {
			return {
				success: false,
				reply: \"That user does not have their location set!\"
			};
		}
		else if (userData.Data.location.hidden) {
			return {
				success: false,
				reply: \"That user has hidden their precise location!\"
			};
		}
		else if (!userData.Data.location.components.country) {
			return {
				success: false,
				reply: \"That user does not have their country location set!\"
			};
		}

		country = userData.Data.location.components.country;
	}

	if (input === \"top\") {
		const result = (await this.staticData.fetch.topData(10))
			.map((i, ind) => `#${ind + 1}: ${i.Country} (${i.All_Cases})`)
			.join(\"; \");

		return {
			reply: \"Top 10 countries by cases: \" + result
		};
	}
	else if (input.includes(\":\")) {
		[region, country] = input.split(\":\").map(i => i.trim());
	}
	else if (input.length > 0) {
		country = input;
	}

	if (this.staticData.regions.includes(input)) {
		region = input;
		targetData = await this.staticData.fetch.regionalData(region);
	}
	else if (country) {
		const [loose, strict] = await Promise.all([
			this.staticData.fetch.countryData(region, country, false),
			this.staticData.fetch.countryData(region, country, true)
		]);

		const result = sb.Utils.selectClosestString(
			country,
			[loose[0]?.Name, strict[0]?.Name].filter(Boolean),
			{ ignoreCase: true }
		);

		targetData = [loose, strict].find(i => i[0]?.Name && i[0].Name.toLowerCase() === result.toLowerCase());
	}
	else {
		targetData = await this.staticData.fetch.regionalData(null);
	}

	if (!targetData || targetData.length === 0) {
		return {
			reply: \"That country has no Corona virus data available!\"
		};
	}
	
	const { Region: prettyRegion } = targetData[0];
	if (targetData.length === 1) {
		targetData = targetData[0];
	}
	else if (targetData.length > 1) {
		targetData = this.staticData.sumObjectArray(targetData);
	}

	let intro = null;
	if (region) {
		intro = prettyRegion;
	}
	else if (!targetData.Parent) {
		intro = await this.staticData.getEmoji(targetData.Name ?? null);
		if (!intro) {
			intro = targetData.Name;
		}
	}
	else {
		const emoji = await this.staticData.getEmoji(targetData.Parent);
		intro = `${targetData.Name} (${emoji})`;
	}

	const {
		All_Cases: allCases,
		All_Deaths: allDeaths,
		All_Recoveries: allRecoveries,
		New_Cases: newCases,
		New_Deaths: newDeaths,
	} = targetData;

	const plusCases = (newCases > 0) ? ` (+${newCases})` : \"\";
	const plusDeaths = (newDeaths > 0) ? ` (+${newDeaths})` : \"\";
	return {
		reply: `${intro} has ${allCases} confirmed case${(allCases === 1) ? \"\" : \"s\"}${plusCases}, ${allDeaths ?? \"no\"} death${(allDeaths === 1) ? \"\" : \"s\"}${plusDeaths} and ${allRecoveries ?? \"no\"} recovered case${(allRecoveries === 1) ? \"\" : \"s\"}.`
	};
})'