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
		15000,
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
		'(async function corona (context, ...args) {
	if (!this.data.cache || sb.Date.now() > this.data.nextReload) {
		const html = await sb.Got.instances.FakeAgent(\"https://www.worldometers.info/coronavirus/\").text();
		const $ = sb.Utils.cheerio(html);
		const rows = Array.from($(\"#main_table_countries tbody tr\"));

		this.data.cache = [];
		for (const row of rows) {
			let [country, confirmed, newCases, deaths, newDeaths, active, recovered, critical] = Array.from($(row).children()).map((i, ind) => {
				let value = $(i).text();
				if (ind !== 0) {
					value = Number(value.replace(/,/g, \"\")) || 0;
				}

				return value;
			});

			country = country.trim();

			// Fixing special cases
			if (country === \"S. Korea\") {
				country = \"South Korea\";
			}
			// Fixing \"U.A.E.\" and \"U.K.\"
			country = country.replace(/\\./g, \"\");

			this.data.cache.push({
				country, confirmed, newCases, deaths, newDeaths, recovered, critical, active
			});
		}

		const [confirmed, deaths, recovered] = $(\".maincounter-number\").text().replace(/,/g, \"\").split(\" \").filter(Boolean).map(Number);
		const [mild, critical] = Array.from($(\".number-table\")).map(i => Number(i.firstChild.nodeValue.replace(/,/g, \"\")));

		this.data.total = { confirmed, deaths, recovered, critical, mild };

		this.data.update = new sb.Date().valueOf();
		this.data.pastebinLink = null;
		this.data.nextReload = new sb.Date().addMinutes(30).valueOf();
	}

	if (args[0] === \"dump\" || args[0] === \"json\") {
		if (!this.data.pastebinLink) {
			this.data.pastebinLink = await sb.Pastebin.post(JSON.stringify(this.data, null, 4), { format: \"json\" });
		}

		return {
			reply: this.data.pastebinLink
		};
	}

	const inputCountry = args.join(\" \").toLowerCase();
	const targetData = (args.length > 0)
		? this.data.cache.find(i => i.country.toLowerCase().includes(inputCountry))
		: this.data.total;

	if (targetData) {
		const delta = sb.Utils.timeDelta(new sb.Date(this.data.update));
		const { confirmed, deaths, newCases, newDeaths, recovered, country, critical, mild } = targetData;

		if (args.length > 0) {
			const plusCases = (newCases > 0) ? ` (+${newCases})` : \"\";
			const plusDeaths = (newDeaths > 0) ? ` (+${newDeaths})` : \"\";

			return {
				reply: `${country} has ${confirmed} confirmed case${(confirmed === 1) ? \"\" : \"s\"}${plusCases}, ${deaths ?? \"no\"} death${(deaths === 1) ? \"\" : \"s\"}${plusDeaths} and ${recovered ?? \"no\"} recovered case${(recovered === 1) ? \"\" : \"s\"}. Last update: ${delta}`
			}
		}
		else {
			return {
				reply: `${confirmed} corona virus cases are tracked so far. ${mild} are in mild, and ${critical} in critical condition; ${recovered} have fully recovered, and there are ${deaths} deceased. Last check: ${delta}`
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
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function corona (context, ...args) {
	if (!this.data.cache || sb.Date.now() > this.data.nextReload) {
		const html = await sb.Got.instances.FakeAgent(\"https://www.worldometers.info/coronavirus/\").text();
		const $ = sb.Utils.cheerio(html);
		const rows = Array.from($(\"#main_table_countries tbody tr\"));

		this.data.cache = [];
		for (const row of rows) {
			let [country, confirmed, newCases, deaths, newDeaths, active, recovered, critical] = Array.from($(row).children()).map((i, ind) => {
				let value = $(i).text();
				if (ind !== 0) {
					value = Number(value.replace(/,/g, \"\")) || 0;
				}

				return value;
			});

			country = country.trim();

			// Fixing special cases
			if (country === \"S. Korea\") {
				country = \"South Korea\";
			}
			// Fixing \"U.A.E.\" and \"U.K.\"
			country = country.replace(/\\./g, \"\");

			this.data.cache.push({
				country, confirmed, newCases, deaths, newDeaths, recovered, critical, active
			});
		}

		const [confirmed, deaths, recovered] = $(\".maincounter-number\").text().replace(/,/g, \"\").split(\" \").filter(Boolean).map(Number);
		const [mild, critical] = Array.from($(\".number-table\")).map(i => Number(i.firstChild.nodeValue.replace(/,/g, \"\")));

		this.data.total = { confirmed, deaths, recovered, critical, mild };

		this.data.update = new sb.Date().valueOf();
		this.data.pastebinLink = null;
		this.data.nextReload = new sb.Date().addMinutes(30).valueOf();
	}

	if (args[0] === \"dump\" || args[0] === \"json\") {
		if (!this.data.pastebinLink) {
			this.data.pastebinLink = await sb.Pastebin.post(JSON.stringify(this.data, null, 4), { format: \"json\" });
		}

		return {
			reply: this.data.pastebinLink
		};
	}

	const inputCountry = args.join(\" \").toLowerCase();
	const targetData = (args.length > 0)
		? this.data.cache.find(i => i.country.toLowerCase().includes(inputCountry))
		: this.data.total;

	if (targetData) {
		const delta = sb.Utils.timeDelta(new sb.Date(this.data.update));
		const { confirmed, deaths, newCases, newDeaths, recovered, country, critical, mild } = targetData;

		if (args.length > 0) {
			const plusCases = (newCases > 0) ? ` (+${newCases})` : \"\";
			const plusDeaths = (newDeaths > 0) ? ` (+${newDeaths})` : \"\";

			return {
				reply: `${country} has ${confirmed} confirmed case${(confirmed === 1) ? \"\" : \"s\"}${plusCases}, ${deaths ?? \"no\"} death${(deaths === 1) ? \"\" : \"s\"}${plusDeaths} and ${recovered ?? \"no\"} recovered case${(recovered === 1) ? \"\" : \"s\"}. Last update: ${delta}`
			}
		}
		else {
			return {
				reply: `${confirmed} corona virus cases are tracked so far. ${mild} are in mild, and ${critical} in critical condition; ${recovered} have fully recovered, and there are ${deaths} deceased. Last check: ${delta}`
			}
		}
	}
	else {
		return {
			reply: \"That country has no Corona virus data available.\"
		};
	}
})'