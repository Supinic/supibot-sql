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
		51,
		'uptime',
		NULL,
		'Posts the uptime of a given stream, or the channel you\'re in, if none is provided.',
		10000,
		0,
		0,
		1,
		0,
		NULL,
		0,
		0,
		0,
		1,
		1,
		1,
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
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function uptime (extra, channel) {
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
})'