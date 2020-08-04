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
		184,
		'schedule',
		NULL,
		'mention,opt-out,pipe',
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
		let extra = \"\";
		if (data.interruption) {
			const { endAt, reason } = data.interruption;
			const end = new sb.Date(endAt);

			if (sb.Date.now() <= end) {
				extra = `Stream schedule is interrupted - reason: ${reason}, will be back ${sb.Utils.timeDelta(end)}.`;
			}
		}

		const game = (data.nextStream.game === \"No game set\")
			? \"(no category)\"
			: data.nextStream.game;

		const title = (data.nextStream.title === \"\")
			? \"(no title)\"
			: data.nextStream.title;

		let target = `${channelName}\'s`;
		if (channelName === context.user.Name) {
			target = \"Your\";
			extra += \" (shouldn\'t you know when you\'re supposed to stream? 😉)\";
		}

		const time = sb.Utils.timeDelta(new sb.Date(data.nextStream.startsAt));
		return {
			reply: `${target} next stream: ${game} - ${title}, starting ${time}. ${extra}`
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
			reply: \"Unexpected API result monkaS @leppunen @supinic\"
		};
	}
})',
		NULL,
		'supinic/supibot-sql'
	)