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
		116,
		'followage',
		'[\"fa\"]',
		'Fetches the followage <user> <channel>. If no channel provided, checks the current one. If no user provided either, checks yourself.',
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
		'(async function followAge (context, user, channel) {
	if (!channel) {
		if (!context.channel) {
			return {
				reply: \"There is no channel to use here!\"
			};
		}

		if (context.platform.Name === \"twitch\") {
			channel = context.channel.Name;	
		}
		else if (context.channel.Mirror) {
			const mirrorChannel = sb.Channel.get(context.channel.Mirror);
			if (mirrorChannel.Platform.Name === \"twitch\") {
				channel = mirrorChannel.Name;
			}
		}
		
		if (!channel) {
			return {
				reply: \"Could not find any associated Twitch channels! Please specify one.\"
			};
		}
	}
	
	if (!user) {
		user = context.user.Name;
	}

	user = user.toLowerCase();

	if (user === channel.toLowerCase()) {
		if (user === context.user.Name) {
			return { reply: \"Good luck following yourself! PepeLaugh\" };
		}
		else {
			return { reply: \"Good luck to them following themselves! PepeLaugh\" };
		}
	}

	const url = `https://api.2g.be/twitch/followage/${channel}/${user}?format=mwdhms`;
	let data = await sb.Utils.request({
		url: url,
		headers: {
			\"User-Agent\": \"Supibot@https://twitch.tv/supibot\"
		}
	});

	if (/following.*for/.test(data)) {
		const split = data.split(\" for \");
		if (split.length < 2) {
			const errorID = await sb.SystemLogger.sendError(\"Other\", new Error(\"Logging stack for followage\"), {user, channel});						return { 
				reply: \"Twitch API responded in an unexpcted way! Please contact @supinic to fix with error ID: \" + errorID
			};
		}

		const delta = sb.Utils.timeDelta(sb.Date.now() - sb.Utils.parseDuration(split[1].trim(), \"ms\"));
		data = split[0] + \" for \" + delta.replace(/\\s*ago\\s*/, \"\") + \".\";
	}
	else if (data.includes(\"not following\")) {
		data += \".\";
	}

	return { reply: data };
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function followAge (context, user, channel) {
	if (!channel) {
		if (!context.channel) {
			return {
				reply: \"There is no channel to use here!\"
			};
		}

		if (context.platform.Name === \"twitch\") {
			channel = context.channel.Name;	
		}
		else if (context.channel.Mirror) {
			const mirrorChannel = sb.Channel.get(context.channel.Mirror);
			if (mirrorChannel.Platform.Name === \"twitch\") {
				channel = mirrorChannel.Name;
			}
		}
		
		if (!channel) {
			return {
				reply: \"Could not find any associated Twitch channels! Please specify one.\"
			};
		}
	}
	
	if (!user) {
		user = context.user.Name;
	}

	user = user.toLowerCase();

	if (user === channel.toLowerCase()) {
		if (user === context.user.Name) {
			return { reply: \"Good luck following yourself! PepeLaugh\" };
		}
		else {
			return { reply: \"Good luck to them following themselves! PepeLaugh\" };
		}
	}

	const url = `https://api.2g.be/twitch/followage/${channel}/${user}?format=mwdhms`;
	let data = await sb.Utils.request({
		url: url,
		headers: {
			\"User-Agent\": \"Supibot@https://twitch.tv/supibot\"
		}
	});

	if (/following.*for/.test(data)) {
		const split = data.split(\" for \");
		if (split.length < 2) {
			const errorID = await sb.SystemLogger.sendError(\"Other\", new Error(\"Logging stack for followage\"), {user, channel});						return { 
				reply: \"Twitch API responded in an unexpcted way! Please contact @supinic to fix with error ID: \" + errorID
			};
		}

		const delta = sb.Utils.timeDelta(sb.Date.now() - sb.Utils.parseDuration(split[1].trim(), \"ms\"));
		data = split[0] + \" for \" + delta.replace(/\\s*ago\\s*/, \"\") + \".\";
	}
	else if (data.includes(\"not following\")) {
		data += \".\";
	}

	return { reply: data };
})'