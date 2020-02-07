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
		const url = `https://endpoint.ainize.ai/laeyoung/wuhan-coronavirus-api/jhu-edu/latest`;
		const data = JSON.parse(await sb.Utils.request({
			url,
			headers: {
				\"User-Agent\": \"Project Supibot @ https://supinic.com\"
			}
		}));

		this.data.rawCache = data;
		this.data.cache = [];
		for (const record of data) {
			let { countryregion: country, lastupdateutc: date1, lastupdate: date2, confirmed, deaths, recovered } = record;
			confirmed = Number(confirmed);
			deaths = Number(deaths);
			recovered = Number(recovered);

			if (country === \"US\") {
				country = \"USA\";
			}

			const update = new sb.Date(date1 ?? date2).setTimezoneOffset(0);
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
				})
			}
		}
		
		const html = await sb.Utils.request({
			url: `https://www.worldometers.info/coronavirus/`,
			headers: {
				\"User-Agent\": \"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36 OPR/66.0.3515.44\"
			}
		});

		const $ = sb.Utils.cheerio(html);
		const [confirmed, deaths, recovered] = $(\".maincounter-number\").text().replace(/,/g, \"\").split(\" \").filter(Boolean).map(Number);
		const critical = Number($(\"span[style*=\'red\']\").text().replace(/,/g, \"\"));

		this.data.total = { confirmed, deaths, recovered, critical };
		this.data.total.update = new sb.Date().valueOf();

		this.data.nextReload = new sb.Date().addHours(1).valueOf();
	}

	if (args[0] === \"dump\") {
		return {
			reply: await sb.Pastebin.post(JSON.stringify(this.data, null, 4), {
				format: \"json\"
			})
		}
	}

	const inputCountry = args.join(\" \").toLowerCase();
	const targetData = (args.length > 0)
		? this.data.cache.find(i => i.country.toLowerCase().includes(inputCountry))
		: this.data.total;

	if (targetData) {
		const delta = sb.Utils.timeDelta(new sb.Date(targetData.update));
		const { confirmed, deaths, recovered, country } = targetData;
		const prefix = (args.length > 0)
			? `${country} has`
			: \"In total, there are\";

		return {
			reply: `${prefix} ${confirmed} confirmed case${(confirmed === 1) ? \"\" : \"s\"}, ${deaths ?? \"no\"} death${(deaths === 1) ? \"\" : \"s\"} and ${recovered ?? \"no\"} recovered case${(recovered === 1) ? \"\" : \"s\"}. Last update: ${delta}`
		};
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
		const url = `https://endpoint.ainize.ai/laeyoung/wuhan-coronavirus-api/jhu-edu/latest`;
		const data = JSON.parse(await sb.Utils.request({
			url,
			headers: {
				\"User-Agent\": \"Project Supibot @ https://supinic.com\"
			}
		}));

		this.data.rawCache = data;
		this.data.cache = [];
		for (const record of data) {
			let { countryregion: country, lastupdateutc: date1, lastupdate: date2, confirmed, deaths, recovered } = record;
			confirmed = Number(confirmed);
			deaths = Number(deaths);
			recovered = Number(recovered);

			if (country === \"US\") {
				country = \"USA\";
			}

			const update = new sb.Date(date1 ?? date2).setTimezoneOffset(0);
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
				})
			}
		}
		
		const html = await sb.Utils.request({
			url: `https://www.worldometers.info/coronavirus/`,
			headers: {
				\"User-Agent\": \"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36 OPR/66.0.3515.44\"
			}
		});

		const $ = sb.Utils.cheerio(html);
		const [confirmed, deaths, recovered] = $(\".maincounter-number\").text().replace(/,/g, \"\").split(\" \").filter(Boolean).map(Number);
		const critical = Number($(\"span[style*=\'red\']\").text().replace(/,/g, \"\"));

		this.data.total = { confirmed, deaths, recovered, critical };
		this.data.total.update = new sb.Date().valueOf();

		this.data.nextReload = new sb.Date().addHours(1).valueOf();
	}

	if (args[0] === \"dump\") {
		return {
			reply: await sb.Pastebin.post(JSON.stringify(this.data, null, 4), {
				format: \"json\"
			})
		}
	}

	const inputCountry = args.join(\" \").toLowerCase();
	const targetData = (args.length > 0)
		? this.data.cache.find(i => i.country.toLowerCase().includes(inputCountry))
		: this.data.total;

	if (targetData) {
		const delta = sb.Utils.timeDelta(new sb.Date(targetData.update));
		const { confirmed, deaths, recovered, country } = targetData;
		const prefix = (args.length > 0)
			? `${country} has`
			: \"In total, there are\";

		return {
			reply: `${prefix} ${confirmed} confirmed case${(confirmed === 1) ? \"\" : \"s\"}, ${deaths ?? \"no\"} death${(deaths === 1) ? \"\" : \"s\"} and ${recovered ?? \"no\"} recovered case${(recovered === 1) ? \"\" : \"s\"}. Last update: ${delta}`
		};
	}
	else {
		return {
			reply: \"That country has no Corona virus data available.\"
		};
	}
})'