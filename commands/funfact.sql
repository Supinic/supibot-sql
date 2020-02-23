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
		'(async function funFact () {
	const data = await sb.Got({
		prefixUrl: \"https://uselessfacts.jsph.pl/\",
		url: \"random.json\",
		searchParams: \"language=en\"
	}).json();

	return {
		reply: data.text
	};
})',
		'No arguments.',
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function funFact () {
	const data = await sb.Got({
		prefixUrl: \"https://uselessfacts.jsph.pl/\",
		url: \"random.json\",
		searchParams: \"language=en\"
	}).json();

	return {
		reply: data.text
	};
})'