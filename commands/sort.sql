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
		110,
		'sort',
		NULL,
		'Sorts the message provided alphabetically.',
		5000,
		0,
		1,
		0,
		0,
		NULL,
		0,
		0,
		0,
		0,
		1,
		0,
		'(async function sort (context, ...args) {
	if (args.length < 2) {
		return {
			reply: \"You must supply at leats two words!\"
		};
	}

	const reply = args.sort().join(\" \");
	return {
		reply: reply,
		meta: {
			skipCooldown: Boolean(context.append.pipe) // Only skip cooldown if used in a pipe
		}
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function sort (context, ...args) {
	if (args.length < 2) {
		return {
			reply: \"You must supply at leats two words!\"
		};
	}

	const reply = args.sort().join(\" \");
	return {
		reply: reply,
		meta: {
			skipCooldown: Boolean(context.append.pipe) // Only skip cooldown if used in a pipe
		}
	};
})'