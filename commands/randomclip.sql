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
		105,
		'randomclip',
		'[\"rc\"]',
		'Posts a random clip from either the current channel or the specified channel. You can specify a parameter period, with options day/week/month/all, for example: perdiod:week',
		30000,
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
		'(async function randomClip (context, ...args) {
	let channel = context.channel?.Name ?? null;
	if (args.length > 0 && !args[0].includes(\":\")) {
		channel = args[0];
	}

	if (!channel && context.privateMessage || context.platform.Name !== \"twitch\") {
		return {
			reply: \"You must specify the target channel if you\'re in PMs or not on Twitch!\"
		};
	}

	let period = \"all\";
	const allowedPeriods = [\"day\", \"week\", \"month\", \"all\"];
	const regex = new RegExp(\"period:(\" + allowedPeriods.join(\"|\") + \")\", \"i\");
	for (const token of args) {
		const match = token.match(regex);
		if (match) {
			period = match[1].toLowerCase();
		}
	}

	try {
		const params = new sb.URLParams()
			.set(\"period\", period)
			.set(\"channel\", channel || context.channel.Name)
			.set(\"limit\", \"100\");

		const data = JSON.parse(await sb.Utils.request({
			url: `https://api.twitch.tv/kraken/clips/top?${params.toString()}`,
			headers: {
				Accept: \"application/vnd.twitchtv.v5+json\",
				\"Client-ID\":  sb.Config.get(\"TWITCH_CLIENT_ID\")
			}
		}));

		if (data.clips.length === 0) {
			return { reply: \"No clips found!\" };
		}

		const clip = sb.Utils.randArray(data.clips);
		const delta = sb.Utils.timeDelta(new sb.Date(clip.created_at));
		const url = \"https://clips.twitch.tv/\" + clip.slug;

		return {
			reply: `${clip.title} - ${clip.duration} sec, clipped by ${clip.curator.name}, ${delta}: ${url}`
		};
	}
	catch (e) {
		if (e.statusCode === 404) {
			return { reply: \"That user does not exist\" };
		}

		console.error(e);
		return { reply: \"Something else messed up!\" };
	}
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function randomClip (context, ...args) {
	let channel = context.channel?.Name ?? null;
	if (args.length > 0 && !args[0].includes(\":\")) {
		channel = args[0];
	}

	if (!channel && context.privateMessage || context.platform.Name !== \"twitch\") {
		return {
			reply: \"You must specify the target channel if you\'re in PMs or not on Twitch!\"
		};
	}

	let period = \"all\";
	const allowedPeriods = [\"day\", \"week\", \"month\", \"all\"];
	const regex = new RegExp(\"period:(\" + allowedPeriods.join(\"|\") + \")\", \"i\");
	for (const token of args) {
		const match = token.match(regex);
		if (match) {
			period = match[1].toLowerCase();
		}
	}

	try {
		const params = new sb.URLParams()
			.set(\"period\", period)
			.set(\"channel\", channel || context.channel.Name)
			.set(\"limit\", \"100\");

		const data = JSON.parse(await sb.Utils.request({
			url: `https://api.twitch.tv/kraken/clips/top?${params.toString()}`,
			headers: {
				Accept: \"application/vnd.twitchtv.v5+json\",
				\"Client-ID\":  sb.Config.get(\"TWITCH_CLIENT_ID\")
			}
		}));

		if (data.clips.length === 0) {
			return { reply: \"No clips found!\" };
		}

		const clip = sb.Utils.randArray(data.clips);
		const delta = sb.Utils.timeDelta(new sb.Date(clip.created_at));
		const url = \"https://clips.twitch.tv/\" + clip.slug;

		return {
			reply: `${clip.title} - ${clip.duration} sec, clipped by ${clip.curator.name}, ${delta}: ${url}`
		};
	}
	catch (e) {
		if (e.statusCode === 404) {
			return { reply: \"That user does not exist\" };
		}

		console.error(e);
		return { reply: \"Something else messed up!\" };
	}
})'