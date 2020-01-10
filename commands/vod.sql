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
		177,
		'vod',
		NULL,
		'Posts the last VOD of a specified channel (for now)',
		15000,
		0,
		0,
		0,
		0,
		NULL,
		0,
		0,
		0,
		1,
		0,
		0,
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

	const vod = JSON.parse(await sb.Utils.request({
		method: \"GET\",
		url: \"https://api.twitch.tv/helix/videos?user_id=\" + channelID,
		headers: {
			\"Client-ID\": sb.Config.get(\"TWITCH_CLIENT_ID\")
		}
	}));
	
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
	return {
		reply: `${data.title} - published ${delta} ${data.url}${liveString}`
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function vod (context, target) {
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

	const vod = JSON.parse(await sb.Utils.request({
		method: \"GET\",
		url: \"https://api.twitch.tv/helix/videos?user_id=\" + channelID,
		headers: {
			\"Client-ID\": sb.Config.get(\"TWITCH_CLIENT_ID\")
		}
	}));
	
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
	return {
		reply: `${data.title} - published ${delta} ${data.url}${liveString}`
	};
})'