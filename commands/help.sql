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
		49,
		'help',
		'[\"commands\"]',
		'mention,pipe',
		'Posts either: a short list of all commands, or a description of a specific command if you specify it.',
		5000,
		NULL,
		NULL,
		'(async function help (context, commandString) {
	const prefix = sb.Config.get(\"COMMAND_PREFIX\");

	// No specified command - print all available commands in given channel for given user
	if (!commandString || context.invocation === \"commands\") {
		return {
			reply: (!context.channel || context.channel.Links_Allowed)
				? \"Commands available here: https://supinic.com/bot/command/list\"
				: \"Commands available here: supinic dot com/bot/command/list\"
		};
	}
	// Print specific command description
	else {
		const identifier = (sb.Command.is(commandString))
			? commandString.replace(sb.Command.prefix)
			: commandString;

		if (identifier.toLowerCase() === \"me\") {
			return { reply: \"I can\'t directly help you, but maybe if you use one of my commands, you\'ll feel better? :)\" };
		}

		const command = sb.Command.get(identifier);
		if (!command) {
			return { reply: \"That command does not exist!\" };
		}

		const filteredResponse = (command.Flags.whitelist) ? \"(whitelisted)\" : \"\";
		const aliases = (command.Aliases.length === 0) ? \"\" : (\" (\" + command.Aliases.map(i => prefix + i).join(\", \") + \")\");

		const reply = [
			prefix + command.Name + aliases + \":\",
			command.Description || \"(no description)\",
			\"- \" + sb.Utils.round(command.Cooldown / 1000, 1) + \" seconds cooldown.\",
			filteredResponse,
			\"https://supinic.com/bot/command/\" + command.ID
		];

		return { reply: reply.join(\" \") };
	}
})',
		NULL,
		'supinic/supibot-sql'
	)