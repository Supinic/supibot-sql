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
		138,
		'transliterate',
		NULL,
		'Transliterates non-latin text into Latin. Should support most of the languages not using Latin (like Japanese, Chinese, Russian, ...)',
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
		'async (extra, ...args) => {
	if (args.length === 0) {
		return { reply: \"No input provided!\" };
	}

	return { reply: sb.Utils.transliterate(args.join(\" \")) };
}',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async (extra, ...args) => {
	if (args.length === 0) {
		return { reply: \"No input provided!\" };
	}

	return { reply: sb.Utils.transliterate(args.join(\" \")) };
}'