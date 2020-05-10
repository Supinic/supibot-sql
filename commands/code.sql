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
		Dynamic_Description
	)
VALUES
	(
		173,
		'code',
		NULL,
		'ping,pipe',
		'Posts a link to a specific command\'s code definition on supinic.com website.',
		10000,
		NULL,
		NULL,
		'(async function code (context, commandString) {
	if (!commandString) {
		return {
			reply: \"No command provided!\"
		};
	}

	const command = sb.Command.get(commandString);
	if (!command) {
		return {
			reply: \"Provided command does not exist!\"
		};
	}

	return {
		reply: `Website: https://supinic.com/bot/command/${command.ID}/code`
	};	
})',
		NULL
	)