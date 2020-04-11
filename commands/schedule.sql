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
		184,
		'schedule',
		NULL,
		NULL,
		'Posts the channel\'s stream schedule.',
		30000,
		0,
		0,
		0,
		0,
		NULL,
		0,
		1,
		0,
		1,
		1,
		1,
		0,
		NULL,
		'(async function schedule (context, channel) {
	const channelData = (channel)
		? sb.Channel.get(channel)
		: context.channel;

	if (!channelData) {
		return {
			reply: \"Invalid or unknown channel provided!\"
		};
	}

	console.log(channelData);

	if (channelData.Data.schedule) {
		return {
			reply: \"Schedule: \" + channelData.Data.schedule
		};
	}
	else {
		return {
			reply: \"This channel has no schedule set up!\"
		};
	}
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function schedule (context, channel) {
	const channelData = (channel)
		? sb.Channel.get(channel)
		: context.channel;

	if (!channelData) {
		return {
			reply: \"Invalid or unknown channel provided!\"
		};
	}

	console.log(channelData);

	if (channelData.Data.schedule) {
		return {
			reply: \"Schedule: \" + channelData.Data.schedule
		};
	}
	else {
		return {
			reply: \"This channel has no schedule set up!\"
		};
	}
})'