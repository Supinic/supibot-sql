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
		72,
		'optout',
		NULL,
		NULL,
		'Makes it so you cannot be the target of a command. The command will not be executed. You can also append a message to explain why you opted out.',
		5000,
		0,
		0,
		1,
		0,
		NULL,
		0,
		0,
		0,
		1,
		0,
		0,
		0,
		NULL,
		'(async function optOut (context, command, ...args) {
	if (!command) {
		return { reply: \"No command provided!\" };
	}

	if (command === \"all\") {
		context.user.Data.universalOptOut = !context.user.Data.universalOptOut;
		await context.user.saveProperty(\"Data\", context.user.Data);

		return { reply: \"Your universal opt-out flag is now set to \" + context.user.Data.universalOptOut };
	}

	command = sb.Command.get(command);
	if (!command) {
		return { reply: \"Invalid command provided!\" };
	}
	else if (!command.Opt_Outable) {
		return { reply: \"You cannot opt out from that command!\" };
	}
	
	const customReason = args.join(\" \") || null;
	const existingFilter = sb.Filter.data.find(i => (
		i.User_Alias === context.user.ID
		&& i.Command === command.ID
		&& i.Type === \"Opt-out\"
	));

	const customLimit = sb.Config.get(\"CUSTOM_OPTOUT_LIMIT\");
	if (customReason && customReason.length > customLimit) {
		return { 
			reply: `Custom opt-out message is too long! (${customReason.length}/${customLimit})`
		};
	}

	const paddedReason = (customReason)
		? (\"Opted out: \" + customReason)
		: null;

	if (!existingFilter) {
		const filter = await sb.Filter.create({
			User_Alias: context.user.ID,
			Command: command.ID,
			Type: \"Opt-out\",
			Response: \"Auto\",
			Issued_By: context.user.ID
		});

		await filter.setReason(paddedReason);		

		return { reply: \"You are now opted out from command \" + sb.Master.commandPrefix + command.Name + \".\" };
	}
	else {
		const filter = sb.Filter.get(existingFilter.ID);
		const verb = (!filter.Active) ? \"again\" : \"no longer\";

		await filter.toggle();
		await filter.setReason(paddedReason);

		return { reply: \"You are now \" + verb + \" opted out from command \" + sb.Master.commandPrefix + command.Name + \".\" };
	}
})',
		NULL,
		'async (prefix) => {
	return [
		\"Opts you out of a specific command.\",
		\"While opted out, nobody can used that command with you as the parameter.\",
		\"You can also use a custom message to explain why you opted out or the reasoning.\",
		\"\",
		`${prefix}optout rl => You are now opted out from rl`,
		`${prefix}optout rl Just because. => You are now opted out from rl`
	];
}'
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function optOut (context, command, ...args) {
	if (!command) {
		return { reply: \"No command provided!\" };
	}

	if (command === \"all\") {
		context.user.Data.universalOptOut = !context.user.Data.universalOptOut;
		await context.user.saveProperty(\"Data\", context.user.Data);

		return { reply: \"Your universal opt-out flag is now set to \" + context.user.Data.universalOptOut };
	}

	command = sb.Command.get(command);
	if (!command) {
		return { reply: \"Invalid command provided!\" };
	}
	else if (!command.Opt_Outable) {
		return { reply: \"You cannot opt out from that command!\" };
	}
	
	const customReason = args.join(\" \") || null;
	const existingFilter = sb.Filter.data.find(i => (
		i.User_Alias === context.user.ID
		&& i.Command === command.ID
		&& i.Type === \"Opt-out\"
	));

	const customLimit = sb.Config.get(\"CUSTOM_OPTOUT_LIMIT\");
	if (customReason && customReason.length > customLimit) {
		return { 
			reply: `Custom opt-out message is too long! (${customReason.length}/${customLimit})`
		};
	}

	const paddedReason = (customReason)
		? (\"Opted out: \" + customReason)
		: null;

	if (!existingFilter) {
		const filter = await sb.Filter.create({
			User_Alias: context.user.ID,
			Command: command.ID,
			Type: \"Opt-out\",
			Response: \"Auto\",
			Issued_By: context.user.ID
		});

		await filter.setReason(paddedReason);		

		return { reply: \"You are now opted out from command \" + sb.Master.commandPrefix + command.Name + \".\" };
	}
	else {
		const filter = sb.Filter.get(existingFilter.ID);
		const verb = (!filter.Active) ? \"again\" : \"no longer\";

		await filter.toggle();
		await filter.setReason(paddedReason);

		return { reply: \"You are now \" + verb + \" opted out from command \" + sb.Master.commandPrefix + command.Name + \".\" };
	}
})'