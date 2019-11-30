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
		97,
		'gachi',
		'[\"gachilist\", \"gl\"]',
		'Posts the link of gachimuchi list on supinic.com',
		10000,
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
		'async () => ({ reply: \"https://supinic.com/gachi/list\" })',
		'No arguments.',
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async () => ({ reply: \"https://supinic.com/gachi/list\" })'