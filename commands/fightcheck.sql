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
		144,
		'fightcheck',
		'[\"foodcheck\"]',
		'Posts all Twitch Food-Fight related emotes.',
		30000,
		0,
		0,
		0,
		0,
		NULL,
		0,
		0,
		0,
		0,
		1,
		1,
		'async () => ({
	reply: \"use $emotecheck food instead :)\"
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async () => ({
	reply: \"use $emotecheck food instead :)\"
})'