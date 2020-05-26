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
		189,
		'pick',
		NULL,
		'ping,pipe',
		'Picks a single word from the provided list of words in a message.',
		10000,
		NULL,
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
		'supinic/supibot-sql'
	)