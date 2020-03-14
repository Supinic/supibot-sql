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
		146,
		'pastebin',
		NULL,
		'Takes the result of a different command (pipe-only) and posts a Pastebin paste with it.',
		20000,
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
		NULL,
		'async (extra, ...args) => {
	if (args.length === 0) {
		return { reply: \"No input provided!\" };
	}

	return {
		reply: await sb.Pastebin.post(args.join(\" \"))
	};
}',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async (extra, ...args) => {
	if (args.length === 0) {
		return { reply: \"No input provided!\" };
	}

	return {
		reply: await sb.Pastebin.post(args.join(\" \"))
	};
}'