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
		154,
		'streaminfo',
		'[\"si\", \"uptime\"]',
		'ping,pipe',
		'Posts stream info about a Twitch channel.',
		10000,
		NULL,
		NULL,
		'(async function streamInfo (context, ...args) {
	let platform = \"twitch\";
	for (let i = 0; i < args.length; i++) {
		const token = args[i];
		if (token === \"mixer\") {
			platform = \"mixer\";
			args.splice(i, 1);
		}
	}

	const target = args.join(\"_\") || context.channel.Name;
	if (platform === \"twitch\") {
		const targetData = await sb.User.get(target);
		const channelID = targetData?.Twitch_ID ?? await sb.Utils.getTwitchID(target);
		if (!channelID) {
			return {
				reply: \"That channel does not exist!\"
			};
		}

		const data = await sb.Got.instances.Twitch.Kraken(\"streams/\" + channelID).json();
		if (data === null || data.stream === null) {
			const { data } = await sb.Got.instances.Twitch.Helix({
				url: \"videos\",
				searchParams: \"user_id=\" + channelID
			}).json();

			if (data.length === 0) {
				return {
					reply: `Channel is offline.`
				};
			}

			let mult = 1000;
			const { created_at: created, duration } = data[0];
			const vodDuration = duration.split(/\\D/).filter(Boolean).map(Number).reverse().reduce((acc, cur) => {
				acc += cur * mult;
				mult *= 60;
				return acc;
			}, 0);

			const delta = sb.Utils.timeDelta(new sb.Date(created).valueOf() + vodDuration, true);
			return {
				reply: `Channel has been offline for ${delta}.`
			};
		}

		const stream = data.stream;
		const started = sb.Utils.timeDelta(new sb.Date(stream.created_at));
		return {
			reply: `${target} is playing ${stream.game} since ${started} for ${stream.viewers} viewers at ${stream.video_height}p. Title: ${stream.channel.status} https://twitch.tv/${target.toLowerCase()}`
		};
	}
	else if (platform === \"mixer\") {
		const data = await sb.Got.instances.Mixer(\"channels/\" + target).json();

		if (data.error) {
			return { reply: data.statusCode + \": \" + data.message };
		}
		else if (data.online) {
			const delta = sb.Utils.timeDelta(new sb.Date(data.updatedAt));
			return {
				reply: `${data.token} is currently live, playing ${data.type.name} for ${data.viewersCurrent} viewers since ${delta}. Title: ${data.name} https://mixer.com/${data.token}`
			};
		}
		else {
			return { reply: `Mixer stream is currently offline.` };
		}
	}
})',
		NULL,
		'supinic/supibot-sql'
	)