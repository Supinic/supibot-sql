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
		165,
		'discord',
		NULL,
		'Posts the link to the current channel\'s Discord(?)',
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
		'(async function discord (context) {
	return { reply: \"Join the Hackerman club today! Now with subscriber emotes supiniOkay https://discord.gg/wHWjRzp\" };
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function discord (context) {
	return { reply: \"Join the Hackerman club today! Now with subscriber emotes supiniOkay https://discord.gg/wHWjRzp\" };
})'