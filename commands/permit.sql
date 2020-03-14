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
		Static_Data,
		Code,
		Examples,
		Dynamic_Description
	)
VALUES
	(
		15,
		'permit',
		NULL,
		'Grants a given user the right to execute a given command',
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
		1,
		NULL,
		'async (extra, user, command) => {
	if (!user || !command) {
		return { reply: \"Select a user and a command!\" };
	}

	const prefix = sb.Config.get(\"COMMAND_PREFIX\");
	if (command.charAt(0) !== prefix || user.charAt(0) === prefix) {
		return { reply: `Must use syntax ${prefix}permit <user> ${prefix}<command>!` };
	}

	const targetUser = await sb.User.get(user, true);
	if (!targetUser) {
		return { reply: \"That user does not exist! (yet?)\" };
	}

	const targetCommand = sb.Command.get(command.replace(prefix, \"\"));
	if (!targetCommand) {
		return { reply: \"That command does not exist!\" };
	}

	await sb.Query.raw([
		\"INSERT INTO chat_data.Elevated_Command_Access (User_Alias, Command, Permitted)\",
		\"VALUES (\" + targetUser.ID + \", \" + targetCommand.ID + \", 1)\",
		\"ON DUPLICATE KEY UPDATE Permitted = 1\"
	].join(\" \"));
	await sb.Command.reloadData();

	return { reply: targetUser.Name + \" has been granted successfully granted permission.\" };
}',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async (extra, user, command) => {
	if (!user || !command) {
		return { reply: \"Select a user and a command!\" };
	}

	const prefix = sb.Config.get(\"COMMAND_PREFIX\");
	if (command.charAt(0) !== prefix || user.charAt(0) === prefix) {
		return { reply: `Must use syntax ${prefix}permit <user> ${prefix}<command>!` };
	}

	const targetUser = await sb.User.get(user, true);
	if (!targetUser) {
		return { reply: \"That user does not exist! (yet?)\" };
	}

	const targetCommand = sb.Command.get(command.replace(prefix, \"\"));
	if (!targetCommand) {
		return { reply: \"That command does not exist!\" };
	}

	await sb.Query.raw([
		\"INSERT INTO chat_data.Elevated_Command_Access (User_Alias, Command, Permitted)\",
		\"VALUES (\" + targetUser.ID + \", \" + targetCommand.ID + \", 1)\",
		\"ON DUPLICATE KEY UPDATE Permitted = 1\"
	].join(\" \"));
	await sb.Command.reloadData();

	return { reply: targetUser.Name + \" has been granted successfully granted permission.\" };
}'