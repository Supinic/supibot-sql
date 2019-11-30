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
		'async () => ({ reply: JSON.parse(await sb.Utils.request(\"https://api.kanye.rest/\")).quote })',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async () => ({ reply: JSON.parse(await sb.Utils.request(\"https://api.kanye.rest/\")).quote })'