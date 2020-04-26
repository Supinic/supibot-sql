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
		146,
		'pastebin',
		NULL,
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
		0,
		NULL,
		'(async function pastebin (context, ...args) {
	if (args.length === 0) {
		return {
			success: false,
			reply: \"No input provided!\"
		};
	}

	return {
		reply: await sb.Pastebin.post(args.join(\" \"))
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function pastebin (context, ...args) {
	if (args.length === 0) {
		return {
			success: false,
			reply: \"No input provided!\"
		};
	}

	return {
		reply: await sb.Pastebin.post(args.join(\" \"))
	};
})'