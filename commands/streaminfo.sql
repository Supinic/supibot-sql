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
		154,
		'streaminfo',
		'[\"si\"]',
		'Posts stream info about a Twitch channel.',
		10000,
		0,
		0,
		0,
		0,
		NULL,
		0,
		0,
		0,
		1,
		1,
		0,
		'(async function streamInfo (context, ...args) {
	let platform = \"twitch\";
	for (let i = 0; i < args.length; i++) {
		const token = args[i];
		if (token === \"mixer\") {
			platform = \"mixer\";
			args.splice(i, 1);
		}
	}

	const target = args.join(\"_\");
	if (!target) {
		return { reply: \"No channel provided!\" };
	}

	if (platform === \"twitch\") {
		let channelID = null;
		const targetData = await sb.User.get(target);
		if (targetData && targetData.Twitch_ID) {
			channelID = targetData.Twitch_ID;
		}
		else {
			const channelInfo = JSON.parse(await sb.Utils.request({
				method: \"GET\",
				url: \"https://api.twitch.tv/kraken/users?login=\" + target,
				headers: {
					\"Client-ID\": sb.Config.get(\"TWITCH_CLIENT_ID\"),
					Accept: \"application/vnd.twitchtv.v5+json\"
				}
			}));

			if (channelInfo._total === 0) {
				return { reply: \"Channel does not exist!\" };
			}

			channelID = channelInfo.users[0]._id;
		}

		const data = JSON.parse(await sb.Utils.request({
			method: \"GET\",
			url: \"https://api.twitch.tv/kraken/streams/\" + channelID,
			headers: {
				\"Client-ID\": sb.Config.get(\"TWITCH_CLIENT_ID\"),
				Accept: \"application/vnd.twitchtv.v5+json\"
			}
		}));

		if (data === null || data.stream === null) {
			return { reply: \"Channel is offline.\" };
		}

		const stream = data.stream;
		const started = sb.Utils.timeDelta(new sb.Date(stream.created_at));
		return {
			reply: `${target} is playing ${stream.game} since ${started} for ${stream.viewers} viewers at ${stream.video_height}p. Title: ${stream.channel.status} https://twitch.tv/${target.toLowerCase()}`
		};
	}
	else if (platform === \"mixer\") {
		const data = JSON.parse(await sb.Utils.request({
			url: \"https://mixer.com/api/v1/channels/\" + target
		}));
		
		if (data.error) {
			return { reply: data.statusCode + \": \" + data.message };
		}		
		else if (data.online) {
			const delta = sb.Utils.timeDelta(new sb.Date(data.updatedAt));
			return {
				reply: `${data.token} is currently live, playing ${data.type.name} for ${data.viewersCurrent} since ${delta}. Title: ${data.name} https://mixer.com/${data.token}`
			};
		}
		else {
			return { reply: `Mixer stream is currently offline.` };
		}
	}
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function streamInfo (context, ...args) {
	let platform = \"twitch\";
	for (let i = 0; i < args.length; i++) {
		const token = args[i];
		if (token === \"mixer\") {
			platform = \"mixer\";
			args.splice(i, 1);
		}
	}

	const target = args.join(\"_\");
	if (!target) {
		return { reply: \"No channel provided!\" };
	}

	if (platform === \"twitch\") {
		let channelID = null;
		const targetData = await sb.User.get(target);
		if (targetData && targetData.Twitch_ID) {
			channelID = targetData.Twitch_ID;
		}
		else {
			const channelInfo = JSON.parse(await sb.Utils.request({
				method: \"GET\",
				url: \"https://api.twitch.tv/kraken/users?login=\" + target,
				headers: {
					\"Client-ID\": sb.Config.get(\"TWITCH_CLIENT_ID\"),
					Accept: \"application/vnd.twitchtv.v5+json\"
				}
			}));

			if (channelInfo._total === 0) {
				return { reply: \"Channel does not exist!\" };
			}

			channelID = channelInfo.users[0]._id;
		}

		const data = JSON.parse(await sb.Utils.request({
			method: \"GET\",
			url: \"https://api.twitch.tv/kraken/streams/\" + channelID,
			headers: {
				\"Client-ID\": sb.Config.get(\"TWITCH_CLIENT_ID\"),
				Accept: \"application/vnd.twitchtv.v5+json\"
			}
		}));

		if (data === null || data.stream === null) {
			return { reply: \"Channel is offline.\" };
		}

		const stream = data.stream;
		const started = sb.Utils.timeDelta(new sb.Date(stream.created_at));
		return {
			reply: `${target} is playing ${stream.game} since ${started} for ${stream.viewers} viewers at ${stream.video_height}p. Title: ${stream.channel.status} https://twitch.tv/${target.toLowerCase()}`
		};
	}
	else if (platform === \"mixer\") {
		const data = JSON.parse(await sb.Utils.request({
			url: \"https://mixer.com/api/v1/channels/\" + target
		}));
		
		if (data.error) {
			return { reply: data.statusCode + \": \" + data.message };
		}		
		else if (data.online) {
			const delta = sb.Utils.timeDelta(new sb.Date(data.updatedAt));
			return {
				reply: `${data.token} is currently live, playing ${data.type.name} for ${data.viewersCurrent} since ${delta}. Title: ${data.name} https://mixer.com/${data.token}`
			};
		}
		else {
			return { reply: `Mixer stream is currently offline.` };
		}
	}
})'