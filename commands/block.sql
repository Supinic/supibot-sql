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
		176,
		'block',
		NULL,
		'Blocks a specified user from using a specified command with you as the target.',
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
		1,
		0,
		'(async function block (context, user, command) {
	if (!user || !command) {
		return {
			reply: \"Specify both the user and the command to block!\"
		};
	}

	const commandData = sb.Command.get(command);
	if (!commandData) {
		return {
			reply: \"Invalid command specified!\"
		};
	}
	else if (!commandData.Blockable) {
		return {
			reply: \"You cannot block users from targetting you with this command!\"
		};
	}

	const userData = await sb.User.get(user, true);
	if (!userData) {
		return {
			reply: \"Invalid user specified!\"
		};
	}

	const filter = sb.Filter.data.find(i => (
		i.User_Alias === context.user.ID
		&& i.Blocked_User === userData.ID
		&& i.Type === \"Block\"
		&& i.Command === commandData.ID
	));

	let prefix = \"\";
	if (filter) {
		prefix = (filter.Active) ? \"un\" : \"\";
		await filter.toggle();
	}
	else {
		await sb.Filter.create({
			Active: true,
			User_Alias: context.user.ID,
			Blocked_User: userData.ID,
			Type: \"Block\",
			Command: commandData.ID,
			Channel: null,
			Platform: null,
			Issued_By: context.user.ID
		});
	}

	const commandPrefix = sb.Config.get(\"COMMAND_PREFIX\");
	return {
		reply: `You ${prefix}blocked ${userData.Name} from using the command ${commandPrefix}${commandData.Name} on you.`
	};
	
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function block (context, user, command) {
	if (!user || !command) {
		return {
			reply: \"Specify both the user and the command to block!\"
		};
	}

	const commandData = sb.Command.get(command);
	if (!commandData) {
		return {
			reply: \"Invalid command specified!\"
		};
	}
	else if (!commandData.Blockable) {
		return {
			reply: \"You cannot block users from targetting you with this command!\"
		};
	}

	const userData = await sb.User.get(user, true);
	if (!userData) {
		return {
			reply: \"Invalid user specified!\"
		};
	}

	const filter = sb.Filter.data.find(i => (
		i.User_Alias === context.user.ID
		&& i.Blocked_User === userData.ID
		&& i.Type === \"Block\"
		&& i.Command === commandData.ID
	));

	let prefix = \"\";
	if (filter) {
		prefix = (filter.Active) ? \"un\" : \"\";
		await filter.toggle();
	}
	else {
		await sb.Filter.create({
			Active: true,
			User_Alias: context.user.ID,
			Blocked_User: userData.ID,
			Type: \"Block\",
			Command: commandData.ID,
			Channel: null,
			Platform: null,
			Issued_By: context.user.ID
		});
	}

	const commandPrefix = sb.Config.get(\"COMMAND_PREFIX\");
	return {
		reply: `You ${prefix}blocked ${userData.Name} from using the command ${commandPrefix}${commandData.Name} on you.`
	};
	
})'