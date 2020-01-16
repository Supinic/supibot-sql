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
		174,
		'addbetween',
		'[\"ab\"]',
		'Fills the message provided with the word (usually an emote) provided as the first argument.',
		30000,
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
		'(async function addBetween (context, word, ...args) {
	if (!word || args.length === 0) {
		return {
			reply: \"Both the word and the message must be provided!\"
		};
	}

	if (args.length === 1) {
		args = Array.from(args[0]);
	}

	const result = [];
	for (const messageWord of args) {
		result.push(word);
		result.push(messageWord);
	}

	result.push(word);
	return {
		reply: result.join(\" \"),
		cooldown: {
			length: (context.append.pipe) ? null : context.command.Cooldown
		}
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function addBetween (context, word, ...args) {
	if (!word || args.length === 0) {
		return {
			reply: \"Both the word and the message must be provided!\"
		};
	}

	if (args.length === 1) {
		args = Array.from(args[0]);
	}

	const result = [];
	for (const messageWord of args) {
		result.push(word);
		result.push(messageWord);
	}

	result.push(word);
	return {
		reply: result.join(\" \"),
		cooldown: {
			length: (context.append.pipe) ? null : context.command.Cooldown
		}
	};
})'