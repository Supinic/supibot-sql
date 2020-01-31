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
		const url = \"https://services1.arcgis.com/0MSEUqKaxRlEPj5g/arcgis/rest/services/ncov_cases/FeatureServer/2/query?\";
		const params = new sb.URLParams()
			.set(\"f\", \"json\")
			.set(\"where\", \"1=1\")
			.set(\"returnGeometry\", \"false\")
			.set(\"outFields\", \"Confirmed,Deaths,Recovered,Country_Region,Last_Update\");

		const data = JSON.parse(await sb.Utils.request({
			url: url + params.toString()
		})).features.map(i => i.attributes);

		let confirmed = 0;
		let deaths = 0;
		let recovered = 0;
		let lastUpdate = -Infinity;

		this.data.cache = data.map(i => {
			if (i.Last_Update > lastUpdate) {
				lastUpdate = i.Last_Update;
			}

			confirmed += i.Confirmed ?? 0;
			deaths += i.Deaths ?? 0;
			recovered += i.Recovered ?? 0;

			if (i.Country_Region === \"US\") {
				i.Country_Region = \"USA\";
			}

			return {
				region: i.Country_Region.trim(),
				confirmed: i.Confirmed,
				deaths: i.Deaths,
				recovered: i.Recovered,
				lastUpdate: i.Last_Update
			};
		});

		this.data.cache.push({
			region: \"Total\",
			confirmed,
			deaths,
			recovered,
			lastUpdate
		});

		this.data.nextReload = new sb.Date().addHours(1).valueOf();
	}

	const data = this.data.cache;
	const country = (args.length > 0)
		? args.join(\" \").toLowerCase()
		: \"total\";

	const countryData = data.find(i => i.region.toLowerCase().includes(country));
	if (countryData) {
		const delta = sb.Utils.timeDelta(new sb.Date(countryData.lastUpdate));
		const { confirmed, deaths, recovered, region } = countryData;
		const prefix = (region === \"Total\")
			? \"In total, there are \"
			: `${region} has `;

		return {
			reply: `${prefix} ${confirmed} confirmed case(s), ${deaths ?? \"no\"} death(s) and ${recovered ?? \"no\"} recovered case(s). Last update: ${delta}.`
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
		const url = \"https://services1.arcgis.com/0MSEUqKaxRlEPj5g/arcgis/rest/services/ncov_cases/FeatureServer/2/query?\";
		const params = new sb.URLParams()
			.set(\"f\", \"json\")
			.set(\"where\", \"1=1\")
			.set(\"returnGeometry\", \"false\")
			.set(\"outFields\", \"Confirmed,Deaths,Recovered,Country_Region,Last_Update\");

		const data = JSON.parse(await sb.Utils.request({
			url: url + params.toString()
		})).features.map(i => i.attributes);

		let confirmed = 0;
		let deaths = 0;
		let recovered = 0;
		let lastUpdate = -Infinity;

		this.data.cache = data.map(i => {
			if (i.Last_Update > lastUpdate) {
				lastUpdate = i.Last_Update;
			}

			confirmed += i.Confirmed ?? 0;
			deaths += i.Deaths ?? 0;
			recovered += i.Recovered ?? 0;

			if (i.Country_Region === \"US\") {
				i.Country_Region = \"USA\";
			}

			return {
				region: i.Country_Region.trim(),
				confirmed: i.Confirmed,
				deaths: i.Deaths,
				recovered: i.Recovered,
				lastUpdate: i.Last_Update
			};
		});

		this.data.cache.push({
			region: \"Total\",
			confirmed,
			deaths,
			recovered,
			lastUpdate
		});

		this.data.nextReload = new sb.Date().addHours(1).valueOf();
	}

	const data = this.data.cache;
	const country = (args.length > 0)
		? args.join(\" \").toLowerCase()
		: \"total\";

	const countryData = data.find(i => i.region.toLowerCase().includes(country));
	if (countryData) {
		const delta = sb.Utils.timeDelta(new sb.Date(countryData.lastUpdate));
		const { confirmed, deaths, recovered, region } = countryData;
		const prefix = (region === \"Total\")
			? \"In total, there are \"
			: `${region} has `;

		return {
			reply: `${prefix} ${confirmed} confirmed case(s), ${deaths ?? \"no\"} death(s) and ${recovered ?? \"no\"} recovered case(s). Last update: ${delta}.`
		};
	}
	else {
		return {
			reply: \"That country has no Corona virus data available.\"
		};
	}
})'