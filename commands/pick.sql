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
		189,
		'pick',
		NULL,
		'Picks a single word from the provided list of words in a message.',
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
		'(async function pick (context, ...words) {
	if (words.length === 0) {
		return {
			reply: \"No input provided!\"
		}
	}

	return {
		reply: sb.Utils.randArray(words)
	}
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function pick (context, ...words) {
	if (words.length === 0) {
		return {
			reply: \"No input provided!\"
		}
	}

	return {
		reply: sb.Utils.randArray(words)
	}
})'