INSERT INTO
	`chat_data`.`Command`
	(
		ID,
		Name,
		Aliases,
		Flags,
		Description,
		Cooldown,
		Whitelist_Response,
		Static_Data,
		Code,
		Dynamic_Description,
		Source
	)
VALUES
	(
		146,
		'pastebin',
		NULL,
		'mention,pipe',
		'Takes the result of a different command (pipe-only) and posts a Pastebin paste with it.',
		20000,
		NULL,
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
		'supinic/supibot-sql'
	)