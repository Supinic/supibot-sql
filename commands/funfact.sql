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
		13,
		'funfact',
		NULL,
		'Fetches a random fun fact. Absolutely not guaranteed to be fun or fact. Want to help out? Send us your own fun fact via the $suggest command!',
		60000,
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
		'async () => {
	const url = \"https://uselessfacts.jsph.pl/random.json?language=en\";
	try {
		const data = await sb.Utils.request(url);
		return {
			reply: JSON.parse(data).text
		};
	}
	catch (e) {
		console.warn(e);
		return {
			reply: \"The API went down FeelsBadMan Want permanent uptime on $funfact? Help us out by posting your own fun facts via the $suggest command!\"
		};
	}
}',
		'No arguments.',
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async () => {
	const url = \"https://uselessfacts.jsph.pl/random.json?language=en\";
	try {
		const data = await sb.Utils.request(url);
		return {
			reply: JSON.parse(data).text
		};
	}
	catch (e) {
		console.warn(e);
		return {
			reply: \"The API went down FeelsBadMan Want permanent uptime on $funfact? Help us out by posting your own fun facts via the $suggest command!\"
		};
	}
}'