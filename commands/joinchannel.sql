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
		59,
		'joinchannel',
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
		'async (extra, channel, mode) => {
	if (!channel.includes(\"#\")) {
		return { reply: \"Channels must be denominated with #, as a safety measure!\" };
	}

	if (mode && mode !== \"Read\") {
		return { reply: \"Only additional mode available is \\\"Read\\\"!\" };
	}

	channel = channel.replace(\"#\", \"\").toLowerCase();

	const newChannel = await sb.Channel.add(channel, 1, mode || \"Write\");
	await sb.Master.clients.twitch.client.join(channel);

	return { reply: \"Success.\" };
}',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async (extra, channel, mode) => {
	if (!channel.includes(\"#\")) {
		return { reply: \"Channels must be denominated with #, as a safety measure!\" };
	}

	if (mode && mode !== \"Read\") {
		return { reply: \"Only additional mode available is \\\"Read\\\"!\" };
	}

	channel = channel.replace(\"#\", \"\").toLowerCase();

	const newChannel = await sb.Channel.add(channel, 1, mode || \"Write\");
	await sb.Master.clients.twitch.client.join(channel);

	return { reply: \"Success.\" };
}'