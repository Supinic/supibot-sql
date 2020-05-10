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
		105,
		'randomclip',
		'[\"rc\"]',
		'ping,pipe',
		'Posts a random clip from either the current channel or the specified channel. You can specify a parameter period, with options day/week/month/all, for example: perdiod:week',
		30000,
		NULL,
		NULL,
		'(async function randomClip (context, ...args) {
	let channel = context.channel?.Name ?? null;
	if (args.length > 0 && !args[0].includes(\":\")) {
		channel = args[0];
	}

	if (!channel && (context.privateMessage || context.platform.Name !== \"twitch\")) {
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
		const data = await sb.Got.instances.Twitch.Kraken({
			url: \"clips/top\",
			searchParams: new sb.URLParams()
				.set(\"period\", period)
				.set(\"channel\", channel || context.channel.Name)
				.set(\"limit\", \"100\")
				.toString()
		}).json();
		
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
		NULL
	)