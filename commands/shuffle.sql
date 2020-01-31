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
		109,
		'shuffle',
		NULL,
		'Shuffles the provided message, word by word.',
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
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function shuffle (context, ...message) {
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
})'