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
		54,
		'ban',
		NULL,
		NULL,
		'Bans any combination of channel, user, and command from being executed.',
		0,
		0,
		1,
		1,
		1,
		NULL,
		0,
		0,
		0,
		1,
		1,
		0,
		0,
		NULL,
		'(async function ban (context, ...args) {
	const options = { Channel: null, User_Alias: null, Command: null, Type: \"Blacklist\" };

	if (args.some(i => i.includes(\"channel:\"))) {
		const chan = args.find(i => i.includes(\"channel:\")).split(\":\")[1];
		options.Channel = (chan === \"this\" || chan === \"here\") 
			? context.channel.ID 
			: sb.Channel.get(chan).ID;
	}
	if (args.some(i => i.includes(\"command:\"))) {
		options.Command = sb.Command.get(args.find(i => i.includes(\"command:\")).split(\":\")[1]).ID;
	}
	if (args.some(i => i.includes(\"user:\"))) {
		options.User_Alias = (await sb.User.get(args.find(i => i.includes(\"user:\"), true).split(\":\")[1])).ID;
	}

	if (!options.Channel && !options.User_Alias && !options.Command) {
		return { reply: \"Didn\'t actually ban anyone Kappa\" };
	}

	const existing = sb.Filter.data.find(i => 
		i.Channel === options.Channel
		&& i.Command === options.Command
		&& i.User_Alias === options.User_Alias
	);

	if (existing) {
		await existing.toggle();
		const prefix = (existing.Active) ? \"re-\" : \"un\";

		return { 
			reply: `Succesfully ${prefix}banned.`
		};
	}
	else {
		const ban = await sb.Filter.create(options);
		return { 
			reply: \"Succesfully banned (ID \" + ban.ID + \")\"
		};
	}
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function ban (context, ...args) {
	const options = { Channel: null, User_Alias: null, Command: null, Type: \"Blacklist\" };

	if (args.some(i => i.includes(\"channel:\"))) {
		const chan = args.find(i => i.includes(\"channel:\")).split(\":\")[1];
		options.Channel = (chan === \"this\" || chan === \"here\") 
			? context.channel.ID 
			: sb.Channel.get(chan).ID;
	}
	if (args.some(i => i.includes(\"command:\"))) {
		options.Command = sb.Command.get(args.find(i => i.includes(\"command:\")).split(\":\")[1]).ID;
	}
	if (args.some(i => i.includes(\"user:\"))) {
		options.User_Alias = (await sb.User.get(args.find(i => i.includes(\"user:\"), true).split(\":\")[1])).ID;
	}

	if (!options.Channel && !options.User_Alias && !options.Command) {
		return { reply: \"Didn\'t actually ban anyone Kappa\" };
	}

	const existing = sb.Filter.data.find(i => 
		i.Channel === options.Channel
		&& i.Command === options.Command
		&& i.User_Alias === options.User_Alias
	);

	if (existing) {
		await existing.toggle();
		const prefix = (existing.Active) ? \"re-\" : \"un\";

		return { 
			reply: `Succesfully ${prefix}banned.`
		};
	}
	else {
		const ban = await sb.Filter.create(options);
		return { 
			reply: \"Succesfully banned (ID \" + ban.ID + \")\"
		};
	}
})'