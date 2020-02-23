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
		163,
		'randomkanyewestquote',
		'[\"rkwq\"]',
		'Posts a random Kanye West quote.',
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
		'(async function randomKanyeWestQuote () {
	const { quote } = await sb.Got(\"https://api.kanye.rest\").json();
	return {
		reply: quote
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function randomKanyeWestQuote () {
	const { quote } = await sb.Got(\"https://api.kanye.rest\").json();
	return {
		reply: quote
	};
})'