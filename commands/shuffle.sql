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
		109,
		'shuffle',
		NULL,
		'pipe',
		'Shuffles the provided message, word by word.',
		10000,
		NULL,
		NULL,
		'(async function shuffle (context, ...message) {
	if (message.length === 0) {
		return { reply: \"No input provided!\" };
	}

	const result = [];
	while (message.length > 0) {
		const randomIndex = sb.Utils.random(0, message.length - 1);
		result.push(message[randomIndex].replace(/[\\[\\]{}()]/g, \"\"));
		message.splice(randomIndex, 1);
	}

	const reply = result.join(\" \");
	return { 
		reply: reply,
		cooldown: {
			length: (context.append.pipe) ? null : this.Cooldown
		}
	};
})',
		NULL,
		'supinic/supibot-sql'
	)