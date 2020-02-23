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
		const owner = \"CSSEGISandData\";
		const repo = \"2019-nCoV\";
		const path = \"csse_covid_19_data/csse_covid_19_daily_reports\";
		const files = await sb.Got.instances.GitHub(`repos/${owner}/${repo}/contents/${path}`).json();

		const { name } = files.filter(i => i.path.includes(\".csv\")).pop();
		const { content } = await sb.Got.instances.GitHub(`repos/${owner}/${repo}/contents/${path}/${name}`).json();

		const regex = /(\\s*\"[^\"]+\"\\s*|\\s*[^,]+|,)(?=,|$)/g;
		const csv = Buffer.from(content, \"base64\").toString();

		// slice(1, -1) gets rid of header and (empty line) footer
		this.data.raw = csv.split(\"\\n\").slice(1, -1).map(i => [...i.matchAll(regex)].map(i => i[0]));
		this.data.cache = [];

		for (const row of this.data.raw) {
			let [province, country, date, confirmed, deaths, recovered] = row;
			if (row.length === 5) {
				[country, date, confirmed, deaths, recovered] = row;
			}

			confirmed = Number(confirmed);
			deaths = Number(deaths);
			recovered = Number(recovered);

			// Just brilliant...
			if (country === \"US\") {
				country = \"USA\";
			}

			const update = new sb.Date(date).setTimezoneOffset(0);
			const existing = this.data.cache.find(i => i.country === country);

			if (existing) {
				existing.confirmed += confirmed;
				existing.deaths += deaths;
				existing.recovered += recovered;

				if (update > existing.update) {
					existing.update = update;
				}
			}
			else {
				this.data.cache.push({
					country,
					confirmed,
					deaths,
					recovered,
					update
				});
			}
		}

		const html = await sb.Got.instances.FakeAgent(\"https://www.worldometers.info/coronavirus/\").text();
		const $ = sb.Utils.cheerio(html);
		const [confirmed, deaths, recovered] = $(\".maincounter-number\").text().replace(/,/g, \"\").split(\" \").filter(Boolean).map(Number);
		const [mild, critical] = Array.from($(\".number-table\")).map(i => Number(i.firstChild.nodeValue.replace(/,/g, \"\")));

		this.data.total = { confirmed, deaths, recovered, critical, mild };
		this.data.total.update = new sb.Date().valueOf();

		this.data.pastebinLink = null;
		this.data.nextReload = new sb.Date().addHours(1).valueOf();
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
		const delta = sb.Utils.timeDelta(new sb.Date(targetData.update));
		const { confirmed, deaths, recovered, country, critical, mild } = targetData;

		if (args.length > 0) {
			return {
				reply: `${country} has ${confirmed} confirmed case${(confirmed === 1) ? \"\" : \"s\"}, ${deaths ?? \"no\"} death${(deaths === 1) ? \"\" : \"s\"} and ${recovered ?? \"no\"} recovered case${(recovered === 1) ? \"\" : \"s\"}. Last update: ${delta}`
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
		const owner = \"CSSEGISandData\";
		const repo = \"2019-nCoV\";
		const path = \"csse_covid_19_data/csse_covid_19_daily_reports\";
		const files = await sb.Got.instances.GitHub(`repos/${owner}/${repo}/contents/${path}`).json();

		const { name } = files.filter(i => i.path.includes(\".csv\")).pop();
		const { content } = await sb.Got.instances.GitHub(`repos/${owner}/${repo}/contents/${path}/${name}`).json();

		const regex = /(\\s*\"[^\"]+\"\\s*|\\s*[^,]+|,)(?=,|$)/g;
		const csv = Buffer.from(content, \"base64\").toString();

		// slice(1, -1) gets rid of header and (empty line) footer
		this.data.raw = csv.split(\"\\n\").slice(1, -1).map(i => [...i.matchAll(regex)].map(i => i[0]));
		this.data.cache = [];

		for (const row of this.data.raw) {
			let [province, country, date, confirmed, deaths, recovered] = row;
			if (row.length === 5) {
				[country, date, confirmed, deaths, recovered] = row;
			}

			confirmed = Number(confirmed);
			deaths = Number(deaths);
			recovered = Number(recovered);

			// Just brilliant...
			if (country === \"US\") {
				country = \"USA\";
			}

			const update = new sb.Date(date).setTimezoneOffset(0);
			const existing = this.data.cache.find(i => i.country === country);

			if (existing) {
				existing.confirmed += confirmed;
				existing.deaths += deaths;
				existing.recovered += recovered;

				if (update > existing.update) {
					existing.update = update;
				}
			}
			else {
				this.data.cache.push({
					country,
					confirmed,
					deaths,
					recovered,
					update
				});
			}
		}

		const html = await sb.Got.instances.FakeAgent(\"https://www.worldometers.info/coronavirus/\").text();
		const $ = sb.Utils.cheerio(html);
		const [confirmed, deaths, recovered] = $(\".maincounter-number\").text().replace(/,/g, \"\").split(\" \").filter(Boolean).map(Number);
		const [mild, critical] = Array.from($(\".number-table\")).map(i => Number(i.firstChild.nodeValue.replace(/,/g, \"\")));

		this.data.total = { confirmed, deaths, recovered, critical, mild };
		this.data.total.update = new sb.Date().valueOf();

		this.data.pastebinLink = null;
		this.data.nextReload = new sb.Date().addHours(1).valueOf();
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
		const delta = sb.Utils.timeDelta(new sb.Date(targetData.update));
		const { confirmed, deaths, recovered, country, critical, mild } = targetData;

		if (args.length > 0) {
			return {
				reply: `${country} has ${confirmed} confirmed case${(confirmed === 1) ? \"\" : \"s\"}, ${deaths ?? \"no\"} death${(deaths === 1) ? \"\" : \"s\"} and ${recovered ?? \"no\"} recovered case${(recovered === 1) ? \"\" : \"s\"}. Last update: ${delta}`
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