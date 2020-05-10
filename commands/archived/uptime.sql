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
		51,
		'uptime',
		NULL,
		'archived,ping,pipe,skip-banphrase',
		'Posts the uptime of a given stream, or the channel you\'re in, if none is provided.',
		10000,
		NULL,
		NULL,
		'(async function uptime (extra, channel) {
	if (!channel) {
		channel = extra.channel.Name;
	}

/*
	const data = JSON.parse(await sb.Utils.request({
		url: \"https://api.twitch.tv/helix/streams?user_login=\" + channel,
		headers: {
			\"Accept\": \"application/vnd.twitchtv.v5+json\",
			\"Client-ID\": sb.Config.get(\"TWITCH_CLIENT_ID\")
		}
	})).data[0];
*/

	const twitchID = await sb.Utils.getTwitchID(channel);
	const vod = JSON.parse(await sb.Utils.request({
		method: \"GET\",
		url: \"https://api.twitch.tv/helix/videos?user_id=\" + twitchID,
		headers: {
			\"Client-ID\": sb.Config.get(\"TWITCH_CLIENT_ID\")
		}
	}));

	

	if (!data) {
		return {
			reply: \"Channel is offline.\"
		};
	}
	else {
		return {
			reply: \"Channel has been online for \" + sb.Utils.timeDelta(new sb.Date(data.started_at), true)
		};
	};
})',
		NULL
	)