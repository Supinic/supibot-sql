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
		15,
		'permit',
		NULL,
		'archived,mention,pipe,skip-banphrase,system,whitelist',
		'Grants a given user the right to execute a given command',
		0,
		NULL,
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
		'supinic/supibot-sql'
	)