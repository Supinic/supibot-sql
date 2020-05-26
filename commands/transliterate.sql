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
		138,
		'transliterate',
		NULL,
		'ping,pipe',
		'Transliterates non-latin text into Latin. Should support most of the languages not using Latin (like Japanese, Chinese, Russian, ...)',
		15000,
		NULL,
		NULL,
		'async (extra, ...args) => {
	if (args.length === 0) {
		return { reply: \"No input provided!\" };
	}

	return { reply: sb.Utils.transliterate(args.join(\" \")) };
}',
		NULL,
		'supinic/supibot-sql'
	)