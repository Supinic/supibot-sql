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
		'(async function corona () {
	const makeURL = (type) => `https://services1.arcgis.com/0MSEUqKaxRlEPj5g/arcgis/rest/services/ncov_cases/FeatureServer/1/query?f=json&outFields=*&outStatistics=%5B%7B\"statisticType\"%3A\"sum\"%2C\"onStatisticField\"%3A\"${type}\"%2C\"outStatisticFieldName\"%3A\"value\"%7D%5D`;

	const [confirmData, deathData] = await Promise.all([
		sb.Utils.request(makeURL(\"Confirmed\")),
		sb.Utils.request(makeURL(\"Deaths\"))
	]);

	console.log({confirmData, deathData});

	const cases = JSON.parse(confirmData).features[0].attributes.value;
	const deaths = JSON.parse(deathData).features[0].attributes.value;
	return {
		reply: `Current stats for the Corona virus: ${cases} confirmed cases, ${deaths} deceased.`
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function corona () {
	const makeURL = (type) => `https://services1.arcgis.com/0MSEUqKaxRlEPj5g/arcgis/rest/services/ncov_cases/FeatureServer/1/query?f=json&outFields=*&outStatistics=%5B%7B\"statisticType\"%3A\"sum\"%2C\"onStatisticField\"%3A\"${type}\"%2C\"outStatisticFieldName\"%3A\"value\"%7D%5D`;

	const [confirmData, deathData] = await Promise.all([
		sb.Utils.request(makeURL(\"Confirmed\")),
		sb.Utils.request(makeURL(\"Deaths\"))
	]);

	console.log({confirmData, deathData});

	const cases = JSON.parse(confirmData).features[0].attributes.value;
	const deaths = JSON.parse(deathData).features[0].attributes.value;
	return {
		reply: `Current stats for the Corona virus: ${cases} confirmed cases, ${deaths} deceased.`
	};
})'