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
		222,
		'whisper',
		'[\"/w\", \"pm\"]',
		'pipe',
		'Usable in pipe only - turns the response into a whisper.',
		1000,
		NULL,
		NULL,
		'(async function whisper (context, ...args) {
	if (!context.append.pipe) {
		return {
			reply: \"This command is only usable in pipes!\",
			cooldown: 5000
		};
	}

	return {
		reply: \"Result of your pipe: \" + args.join(\" \"),
		replyWithPrivateMessage: true
	}
})',
		NULL,
		'supinic/supibot-sql'
	)