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
		103,
		'bot',
		NULL,
		'Posts a summary of what supibot does, and what it is.',
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
		'async () => ({
	reply: \"Supibot is a smol variety and utility bot supiniL running on a smol Raspberry Pi 3B supiniL not primarily designed for moderation supiniHack running on Node.js since Feb 2018.\"
})',
		'No arguments.',
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async () => ({
	reply: \"Supibot is a smol variety and utility bot supiniL running on a smol Raspberry Pi 3B supiniL not primarily designed for moderation supiniHack running on Node.js since Feb 2018.\"
})'