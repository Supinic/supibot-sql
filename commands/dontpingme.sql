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
		181,
		'dontpingme',
		'[\"dpm\", \"pingoptout\", \"unping\"]',
		'ping,pipe',
		'Sets/unsets a command pinging you when it\'s being invoked.',
		5000,
		'Only available for Twitch users on Twitch!',
		NULL,
		'(async function dontPingMe (context, command) {
	if (!command) {
		return {
			reply: \"No command provided!\"
		};
	}
	else if (context.platform.Name !== \"twitch\") {
		return {
			reply: \"Not available outside of Twitch!\"
		};
	}

	const commandData = sb.Command.get(command);
	if (!commandData) {
		return {
			reply: \"Invalid command provided!\"
		};
	}

	const existing = sb.Filter.data.find(i => (
		i.User_Alias === context.user.ID
		&& i.Command === commandData.ID
		&& i.Type === \"Unping\"
	));

	if (existing) {
		await existing.toggle();
		
		const prefix = (existing.Active) ? \"no longer\" : \"again\";
		return {
			reply: `The command \"${commandData.Name}\" will now ${prefix} ping you!`
		};
	}
	else {
		sb.Filter.create({
			Command: commandData.ID,
			User_Alias: context.user.ID,
			Channel: null,
			Type: \"Unping\",
			Active: true,
			Issued_By: context.user.ID
		});

		return {
			reply: `The command \"${commandData.Name}\" will now no longer ping you!`
		};
	}	
})',
		NULL,
		'supinic/supibot-sql'
	)