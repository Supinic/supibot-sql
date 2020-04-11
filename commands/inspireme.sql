INSERT INTO
	`chat_data`.`Command`
	(
		ID,
		Name,
		Aliases,
		Flags,
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
		Owner_Override,
		Archived,
		Static_Data,
		Code,
		Examples,
		Dynamic_Description
	)
VALUES
	(
		132,
		'inspireme',
		NULL,
		NULL,
		'Inspires you. Randomly.',
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
		0,
		NULL,
		'(async function inspireMe () {
	const link = await sb.Got(\"https://inspirobot.me/api?generate=true\").text();
	return {
		reply: link
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function inspireMe () {
	const link = await sb.Got(\"https://inspirobot.me/api?generate=true\").text();
	return {
		reply: link
	};
})'