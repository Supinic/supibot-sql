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
	if (message.length < 2) {
		return { reply: \"You must supply at least two words!\" };
	}

	const result = [];
	while (message.length > 0) {
		const randomIndex = sb.Utils.random(0, message.length - 1);
		result.push(message[randomIndex]);
		message.splice(randomIndex, 1);
	}

	const reply = result.join(\" \");
	if (/^!/.test(result[0]) && context.channel && !context.channel.Ping) {
		return {
			reply: \"Potential abuse detected 🐝🍯. First character: \" + reply[0]
		};
	}	
	else {
		return { 
			reply: reply,
			meta: {
				skipCooldown: Boolean(context.append.pipe) // Only skip cooldown if used within a pipe.
			}
		};
	}
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function shuffle (context, ...message) {
	if (message.length < 2) {
		return { reply: \"You must supply at least two words!\" };
	}

	const result = [];
	while (message.length > 0) {
		const randomIndex = sb.Utils.random(0, message.length - 1);
		result.push(message[randomIndex]);
		message.splice(randomIndex, 1);
	}

	const reply = result.join(\" \");
	if (/^!/.test(result[0]) && context.channel && !context.channel.Ping) {
		return {
			reply: \"Potential abuse detected 🐝🍯. First character: \" + reply[0]
		};
	}	
	else {
		return { 
			reply: reply,
			meta: {
				skipCooldown: Boolean(context.append.pipe) // Only skip cooldown if used within a pipe.
			}
		};
	}
})'