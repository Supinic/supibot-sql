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
		184,
		'schedule',
		NULL,
		'opt-out,ping,pipe',
		'Posts the channel\'s stream schedule.',
		30000,
		NULL,
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
		NULL
	)