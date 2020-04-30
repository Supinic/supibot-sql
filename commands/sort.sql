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
		110,
		'sort',
		NULL,
		NULL,
		'Sorts the message provided alphabetically.',
		5000,
		0,
		0,
		0,
		0,
		NULL,
		0,
		0,
		0,
		0,
		1,
		0,
		0,
		NULL,
		'(async function sort (context, ...args) {
	if (args.length < 2) {
		return {
			success: false,
			reply: \"You must supply at least two words!\"
		};
	}

	const reply = args.sort().join(\" \");
	return {
		reply: reply,
		cooldown: (context.append.pipe)
			? null // skip cooldown in pipe
			: this.Cooldown // apply regular cooldown inside of pipe
	};
})',
		NULL,
		NULL
	)