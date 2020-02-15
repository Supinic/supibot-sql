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
		'externalpipe',
		'[\"epipe\"]',
		NULL,
		0,
		0,
		0,
		0,
		1,
		'Testing. KKona',
		0,
		0,
		0,
		1,
		1,
		0,
		'(async function externalPipe (context, bot, ...rest) {
	if (!context.channel) {
		return {
			reply: \"Can\'t use this command in PMs!\"
		};
	}

	const args = rest.join(\" \").split(\"|\");
	if (args.length < 2) {
		return {
			reply: \"At least two commands must be piped  ogether!\"
		};
	}

	const botData = await sb.User.get(bot);
	if (!botData) {
		return {
			reply: \"That bot name does not exist in the database!\"
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

	// Sends the actual command response
	const safeMessage = await sb.Master.prepareMessage(args.shift(), context.channel);
	await sb.Master.send(safeMessage, context.channel);

	const promise = new sb.Promise();
	sb.Master.data.externalPipePromises.set(key, promise);
	
	setTimeout(() => {
		promise.reject(new Error(\"Promise timed out!\"));
		sb.Master.data.externalPipePromises.delete(key);
	}, 5000);

	let message = null;
	try {
		message = await promise;
	}
	catch (e) {
		return {
			reply: \"Promise rejected! \" + e.message
		};
	}

	args[0] += \" \" + message.replace(/\\|/g, \"\");
	const pipeArguments = args.join(\" | \").split(\" \");
	const pipe = await sb.Command.get(\"pipe\").execute({ externalPipe: true, ...context }, ...pipeArguments);

	console.log({ args, pipe });

	return {
		reply : pipe.reply
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function externalPipe (context, bot, ...rest) {
	if (!context.channel) {
		return {
			reply: \"Can\'t use this command in PMs!\"
		};
	}

	const args = rest.join(\" \").split(\"|\");
	if (args.length < 2) {
		return {
			reply: \"At least two commands must be piped  ogether!\"
		};
	}

	const botData = await sb.User.get(bot);
	if (!botData) {
		return {
			reply: \"That bot name does not exist in the database!\"
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

	// Sends the actual command response
	const safeMessage = await sb.Master.prepareMessage(args.shift(), context.channel);
	await sb.Master.send(safeMessage, context.channel);

	const promise = new sb.Promise();
	sb.Master.data.externalPipePromises.set(key, promise);
	
	setTimeout(() => {
		promise.reject(new Error(\"Promise timed out!\"));
		sb.Master.data.externalPipePromises.delete(key);
	}, 5000);

	let message = null;
	try {
		message = await promise;
	}
	catch (e) {
		return {
			reply: \"Promise rejected! \" + e.message
		};
	}

	args[0] += \" \" + message.replace(/\\|/g, \"\");
	const pipeArguments = args.join(\" | \").split(\" \");
	const pipe = await sb.Command.get(\"pipe\").execute({ externalPipe: true, ...context }, ...pipeArguments);

	console.log({ args, pipe });

	return {
		reply : pipe.reply
	};
})'