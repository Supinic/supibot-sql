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
		59,
		'joinchannel',
		NULL,
		'ping,pipe,system,whitelist',
		'Adds a new channel to database, sets its tables and events, and joins it. Only applicable for Twitch channels (for now, at least).',
		0,
		NULL,
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
	const existing = sb.Channel.get(channel);
	if (existing) {
		return {
			success: false,
			reply: \"This channel already exists in the database, with mode = \" + existing.Mode + \"!\"
		};
	}

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
		'supinic/supibot-sql'
	)