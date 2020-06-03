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
		177,
		'vod',
		NULL,
		'ping',
		'Posts the last VOD of a specified channel. If you use the keyword \"current\", you\'ll get a timestamp as well.',
		15000,
		NULL,
		NULL,
		'(async function vod (context, target, type) {
	if (target === \"current\" && !type) {
		type = target;
		target = null;
	}

	if (!target) {
		if (context.platform.Name === \"twitch\") {
			target = context.channel.Name;
		}
		else {
			return {
				success: false,
				reply: \"You must provide a channel, no default is available outside of Twitch!\"
			};
		}
	}

	const channelID = await sb.Utils.getTwitchID(target);
	if (!channelID) {
		return {
			reply: \"Invalid channel provided!\"
		};
	}

	const vod = await sb.Got.instances.Twitch.Helix({
		url: \"videos\",
		searchParams: \"user_id=\" + channelID
	}).json();

	if (vod.data.length === 0) {
		return {
			reply: \"Target channel has no VODs saved!\"
		};
	}

	let liveString = \"\";
	const isLive = (await sb.Command.get(\"streaminfo\").execute(context, target)).reply;
	if (isLive && !isLive.includes(\"not exist\") && !isLive.includes(\"offline\")) {
		liveString = \" 🔴\";
	}

	const data = vod.data[0];
	const delta = sb.Utils.timeDelta(new sb.Date(data.created_at));
	const prettyDuration = data.duration.match(/\\d+[hm]/g).join(\", \");

	if (type === \"current\") {
		if (!liveString) {			
			return {
				reply: `Channel is not currently live, no current timestamp supported.`
			};
		}

		const stamp = sb.Utils.parseDuration(data.duration, { target: \"sec\" }) - 90;
		return {
			reply: `Current VOD timestamp: ${data.url}?t=${(stamp < 0) ? 0 : stamp}s`
		};
	}

	return {
		reply: `${data.title} (length: ${prettyDuration}) - published ${delta} ${data.url}${liveString}`
	};
})',
		NULL,
		'supinic/supibot-sql'
	)