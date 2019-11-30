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
		14,
		'vanishme',
		NULL,
		'Posts !vanish',
		5000,
		0,
		0,
		1,
		1,
		NULL,
		0,
		0,
		0,
		0,
		1,
		0,
		'async () => ({ reply: \"!vanish monkaS\" })',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async () => ({ reply: \"!vanish monkaS\" })'