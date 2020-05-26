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
		'Posts the last VOD of a specified channel (for now)',
		15000,
		NULL,
		NULL,
		'(async function vod (context, target) {
	if (!target) {
		if (context.platform.Name === \"twitch\") {
			target = context.channel.Name;
		}
		else {
			return {
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

	return {
		reply: `${data.title} (length: ${prettyDuration}) - published ${delta} ${data.url}${liveString}`
	};
})',
		NULL,
		'supinic/supibot-sql'
	)