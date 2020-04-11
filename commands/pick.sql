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
		189,
		'pick',
		NULL,
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
		0,
		NULL,
		'(async function pick (context, ...words) {
	if (words.length === 0) {
		return {
			reply: \"No input provided!\"
		}
	}

	return {
		reply: sb.Utils.randArray(words),
		cooldown: (context.append.pipe)
			? 0
			: this.Cooldown
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
		reply: sb.Utils.randArray(words),
		cooldown: (context.append.pipe)
			? 0
			: this.Cooldown
	}
})'