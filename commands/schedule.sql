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
	let channelName =  null;
	if (channel) {
		channelName = channel;
	}
	else if (context.platform.Name === \"twitch\" && context.channel) {
		channelName = context.channel.Name;
	}

	if (!channelName) {
		return {
			success: false,
			reply: `No channel provided, and there is no default channel to be used!`
		};
	}

	const data = await sb.Got.instances.Leppunen(`twitch/streamschedule/${channelName}`).json();
	if (data.status === 200 && data.nextStream) {
		const {
			game = \"(no category)\",
			title,
			startsAt
		} = data.nextStream;

		const time = sb.Utils.timeDelta(new sb.Date(startsAt));
		return {
			reply: `${channelName}\'s next stream: ${game} - ${title}, starting ${time}.`
		};
	}
	else if (data.error) {
		return {
			reply: `User has not set a stream schedule.`
		};
	}
	else {
		console.warn(\"Unespected schedule result\", data);
		return {
			success: false,
			reply: \"What? monkaS @leppunen @supinic\"
		};
	}
})',
		NULL
	)