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
		110,
		'sort',
		NULL,
		'pipe',
		'Sorts the message provided alphabetically.',
		5000,
		NULL,
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
		'supinic/supibot-sql'
	)