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
		5000,
		NULL,
		NULL,
		'(async function code (context, commandString) {
	if (!commandString) {
		return {
			success: false,
			reply: \"No command provided!\",
			cooldown: 2500
		};
	}

	const command = sb.Command.get(commandString);
	if (!command) {
		return {
			success: false,
			reply: \"Provided command does not exist!\",
			cooldown: 2500
		};
	}

	return {
		reply: `Website: https://supinic.com/bot/command/${command.ID}/code`
	};	
})',
		NULL
	)