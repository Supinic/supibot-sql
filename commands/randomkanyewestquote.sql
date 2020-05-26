INSERT INTO
	`chat_data`.`Command`
	(
		ID,
		Name,
		Aliases,
		Flags,
		Description,
		Cooldown,
		Whitelist_Response,
		Static_Data,
		Code,
		Dynamic_Description,
		Source
	)
VALUES
	(
		163,
		'randomkanyewestquote',
		'[\"rkwq\"]',
		'ping,pipe',
		'Posts a random Kanye West quote.',
		15000,
		NULL,
		NULL,
		'(async function randomKanyeWestQuote () {
	const { quote } = await sb.Got(\"https://api.kanye.rest\").json();
	return {
		reply: quote
	};
})',
		NULL,
		'supinic/supibot-sql'
	)