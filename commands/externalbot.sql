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
		202,
		'externalbot',
		'[\"ebot\"]',
		NULL,
		0,
		0,
		0,
		0,
		1,
		'Currently being tested, and only available to trusted developers',
		0,
		0,
		0,
		1,
		1,
		0,
		'(async function externalBot (context, ...rest) {
	if (!context.channel) {
		return {
			reply: \"Can\'t use this command in PMs!\"
		};
	}
	else if (!context.append.pipe) {
		return {
			reply: \"Can\'t use this command outside of pipe!\"
		};
	}

	if (!this.data.prefixes) {
		this.data.prefixes = await sb.Query.getRecordset(rs => rs
			.select(\"Bot_Alias\", \"Prefix\")
			.from(\"bot_data\", \"Bot\")
			.where(\"Prefix IS NOT NULL\")
			.orderBy(\"LENGTH(Prefix) DESC\")
		);
	}

	let botData = null;
	const message = rest.join(\" \");
	for (const {Prefix: prefix, Bot_Alias: botID} of this.data.prefixes) {
		if (message.startsWith(prefix)) {
			botData = await sb.User.get(botID);
			break;
		}
	}

	if (!botData) {
		return {
			reply: \"No bot with that prefix has been found!\"
		};
	}

	const key = (context.channel.ID + \"_\" + botData.ID);

	if (!sb.Master.data.externalPipePromises) {
		sb.Master.data.externalPipePromises = new Map();
	}
	if (sb.Master.data.externalPipePromises.get(key)) {
		return {
			reply: \"Already awaiting a bot response in this channel!\"
		};
	}

	// Sends the actual external bot\'s command, and wait to see if it responds
	const safeMessage = await sb.Master.prepareMessage(message, context.channel);
	await sb.Master.send(safeMessage, context.channel);

	const promise = new sb.Promise();
	sb.Master.data.externalPipePromises.set(key, promise);

	// Set up a timeout to abort awaiting if the external bot isn\'t replying
	setTimeout(() => {
		sb.Master.data.externalPipePromises.delete(key);
		promise.resolve(null);
	}, 5000);

	const resultMessage = await promise;
	if (resultMessage === null) {
		return {
			error: true,
			reply: \"No response from external bot after 5 seconds!\"
		}
	}

	return {
		reply: resultMessage
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function externalBot (context, ...rest) {
	if (!context.channel) {
		return {
			reply: \"Can\'t use this command in PMs!\"
		};
	}
	else if (!context.append.pipe) {
		return {
			reply: \"Can\'t use this command outside of pipe!\"
		};
	}

	if (!this.data.prefixes) {
		this.data.prefixes = await sb.Query.getRecordset(rs => rs
			.select(\"Bot_Alias\", \"Prefix\")
			.from(\"bot_data\", \"Bot\")
			.where(\"Prefix IS NOT NULL\")
			.orderBy(\"LENGTH(Prefix) DESC\")
		);
	}

	let botData = null;
	const message = rest.join(\" \");
	for (const {Prefix: prefix, Bot_Alias: botID} of this.data.prefixes) {
		if (message.startsWith(prefix)) {
			botData = await sb.User.get(botID);
			break;
		}
	}

	if (!botData) {
		return {
			reply: \"No bot with that prefix has been found!\"
		};
	}

	const key = (context.channel.ID + \"_\" + botData.ID);

	if (!sb.Master.data.externalPipePromises) {
		sb.Master.data.externalPipePromises = new Map();
	}
	if (sb.Master.data.externalPipePromises.get(key)) {
		return {
			reply: \"Already awaiting a bot response in this channel!\"
		};
	}

	// Sends the actual external bot\'s command, and wait to see if it responds
	const safeMessage = await sb.Master.prepareMessage(message, context.channel);
	await sb.Master.send(safeMessage, context.channel);

	const promise = new sb.Promise();
	sb.Master.data.externalPipePromises.set(key, promise);

	// Set up a timeout to abort awaiting if the external bot isn\'t replying
	setTimeout(() => {
		sb.Master.data.externalPipePromises.delete(key);
		promise.resolve(null);
	}, 5000);

	const resultMessage = await promise;
	if (resultMessage === null) {
		return {
			error: true,
			reply: \"No response from external bot after 5 seconds!\"
		}
	}

	return {
		reply: resultMessage
	};
})'