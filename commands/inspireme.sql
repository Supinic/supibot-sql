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
		132,
		'inspireme',
		NULL,
		'ping,pipe',
		'Inspires you. Randomly.',
		15000,
		NULL,
		NULL,
		'(async function inspireMe () {
	const link = await sb.Got(\"https://inspirobot.me/api?generate=true\").text();
	return {
		reply: link
	};
})',
		NULL,
		'supinic/supibot-sql'
	)