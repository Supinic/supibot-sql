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
		59,
		'joinchannel',
		NULL,
		NULL,
		'Adds a new channel to database, sets its tables and events, and joins it. Only applicable for Twitch channels (for now, at least).',
		0,
		0,
		1,
		0,
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
		'(async function joinChannel (context, channel, mode) {
	if (context.platform.Name !== \"twitch\") {
		return {
			success: false,
			reply: \"This command is not available outside of Twitch!\"
		};
	}
	else if (!channel.includes(\"#\")) {
		return { 
			success: false,
			reply: \"Channels must be denominated with #, as a safety measure!\" 
		};
	}
	else if (mode && mode !== \"Read\") {
		return { 
			success: false,
			reply: `Only additional mode available is \"Read\"!`
		};
	}

	channel = channel.replace(\"#\", \"\").toLowerCase();
	const channelID = await sb.Utils.getTwitchID(channel);
	if (!channelID) {
		return {
			success: false,
			reply: \"Could not find provided channel on Twitch!\"
		};
	}

	const newChannel = await sb.Channel.add(channel, context.platform, mode ?? \"Write\", channelID);
	await context.platform.client.join(channel);

	return { reply: \"Success.\" };
})',
		NULL,
		NULL
	)