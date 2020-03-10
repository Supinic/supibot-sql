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

		const html = await sb.Got.instances.FakeAgent(\"https://www.worldometers.info/coronavirus/\").text();
		const $ = sb.Utils.cheerio(html);
		const rows = Array.from($(\"#main_table_countries tbody tr\"));
		
		if (rows.length === 0) {
			this.data.fetching = false;
			return {
				reply: \"The data source website is currently under heavy load or down! Try again later (at least 15s).\",
				cooldown: {
					user: null,
					channel: null,
					length: 15000
				}
			};
		}

		let totalNewCases = 0;
		let totalNewDeaths = 0;

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

			totalNewCases += newCases;
			totalNewDeaths += newDeaths;

			this.data.cache.push({
				country, confirmed, newCases, deaths, newDeaths, recovered, critical, active, cpm
			});
		}

		const [confirmed, deaths, recovered] = $(\".maincounter-number\").text().replace(/,/g, \"\").split(\" \").filter(Boolean).map(Number);
		const [mild, critical] = Array.from($(\".number-table\")).map(i => Number(i.firstChild.nodeValue.replace(/,/g, \"\")));

		this.data.total = { confirmed, deaths, recovered, critical, mild, newCases: totalNewCases, newDeaths: totalNewDeaths };

		this.data.update = new sb.Date().valueOf();
		this.data.pastebinLink = null;
		this.data.nextReload = new sb.Date().addMinutes(30).valueOf();

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

	const inputCountry = args.join(\" \").toLowerCase();
	const targetData = (args.length > 0)
		? this.data.cache.find(i => i.country.toLowerCase().includes(inputCountry))
		: this.data.total;

	if (targetData) {
		const delta = sb.Utils.timeDelta(new sb.Date(this.data.update));
		const { confirmed, deaths, newCases, newDeaths, recovered, country, critical, mild, cpm } = targetData;

		if (args.length > 0) {
			const plusCases = (newCases > 0) ? ` (+${newCases})` : \"\";
			const plusDeaths = (newDeaths > 0) ? ` (+${newDeaths})` : \"\";
			const perMillion = (cpm > 0) ? `This is ${cpm} cases per 1 million people. ` : \"\";

			return {
				reply: `${country} has ${confirmed} confirmed case${(confirmed === 1) ? \"\" : \"s\"}${plusCases}, ${deaths ?? \"no\"} death${(deaths === 1) ? \"\" : \"s\"}${plusDeaths} and ${recovered ?? \"no\"} recovered case${(recovered === 1) ? \"\" : \"s\"}. ${perMillion}Last check: ${delta}.`
			}
		}
		else {
			return {
				reply: `${confirmed} (+${newCases}) corona virus cases are tracked so far. ${mild} are in mild, and ${critical} in critical condition; ${recovered} have fully recovered, and there are ${deaths} (+${newDeaths}) deceased. Last check: ${delta}.`
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

		const html = await sb.Got.instances.FakeAgent(\"https://www.worldometers.info/coronavirus/\").text();
		const $ = sb.Utils.cheerio(html);
		const rows = Array.from($(\"#main_table_countries tbody tr\"));
		
		if (rows.length === 0) {
			this.data.fetching = false;
			return {
				reply: \"The data source website is currently under heavy load or down! Try again later (at least 15s).\",
				cooldown: {
					user: null,
					channel: null,
					length: 15000
				}
			};
		}

		let totalNewCases = 0;
		let totalNewDeaths = 0;

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

			totalNewCases += newCases;
			totalNewDeaths += newDeaths;

			this.data.cache.push({
				country, confirmed, newCases, deaths, newDeaths, recovered, critical, active, cpm
			});
		}

		const [confirmed, deaths, recovered] = $(\".maincounter-number\").text().replace(/,/g, \"\").split(\" \").filter(Boolean).map(Number);
		const [mild, critical] = Array.from($(\".number-table\")).map(i => Number(i.firstChild.nodeValue.replace(/,/g, \"\")));

		this.data.total = { confirmed, deaths, recovered, critical, mild, newCases: totalNewCases, newDeaths: totalNewDeaths };

		this.data.update = new sb.Date().valueOf();
		this.data.pastebinLink = null;
		this.data.nextReload = new sb.Date().addMinutes(30).valueOf();

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

	const inputCountry = args.join(\" \").toLowerCase();
	const targetData = (args.length > 0)
		? this.data.cache.find(i => i.country.toLowerCase().includes(inputCountry))
		: this.data.total;

	if (targetData) {
		const delta = sb.Utils.timeDelta(new sb.Date(this.data.update));
		const { confirmed, deaths, newCases, newDeaths, recovered, country, critical, mild, cpm } = targetData;

		if (args.length > 0) {
			const plusCases = (newCases > 0) ? ` (+${newCases})` : \"\";
			const plusDeaths = (newDeaths > 0) ? ` (+${newDeaths})` : \"\";
			const perMillion = (cpm > 0) ? `This is ${cpm} cases per 1 million people. ` : \"\";

			return {
				reply: `${country} has ${confirmed} confirmed case${(confirmed === 1) ? \"\" : \"s\"}${plusCases}, ${deaths ?? \"no\"} death${(deaths === 1) ? \"\" : \"s\"}${plusDeaths} and ${recovered ?? \"no\"} recovered case${(recovered === 1) ? \"\" : \"s\"}. ${perMillion}Last check: ${delta}.`
			}
		}
		else {
			return {
				reply: `${confirmed} (+${newCases}) corona virus cases are tracked so far. ${mild} are in mild, and ${critical} in critical condition; ${recovered} have fully recovered, and there are ${deaths} (+${newDeaths}) deceased. Last check: ${delta}.`
			}
		}
	}
	else {
		return {
			reply: \"That country has no Corona virus data available.\"
		};
	}
})'