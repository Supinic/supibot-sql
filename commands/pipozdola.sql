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
		Static_Data,
		Code,
		Examples,
		Dynamic_Description
	)
VALUES
	(
		88,
		'pipozdola',
		NULL,
		'PIP OMEGALUL ZD OMEGALUL LA',
		10000,
		0,
		0,
		1,
		1,
		NULL,
		0,
		0,
		0,
		1,
		1,
		0,
		NULL,
		'async () => ({
	reply: \"https://pastebin.com/PzSHPzH0\"
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async () => ({
	reply: \"https://pastebin.com/PzSHPzH0\"
})'