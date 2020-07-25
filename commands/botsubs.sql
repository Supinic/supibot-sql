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
		126,
		'botsubs',
		NULL,
		'mention,pipe',
		'Checks the channels supibot is currently subscribed to on Twitch.',
		10000,
		NULL,
		NULL,
		'(async function botSubs () {
	const controller = sb.Platform.get(\"twitch\").controller;
	const emoteSets = controller.availableEmoteSets;

	if (!this.data.emoteSets || emoteSets.join(\",\") !== this.data.emoteSets.join(\",\")) {
		const { body, statusCode } = await sb.Got({
			throwHttpErrors: false,
			url: \"https://api.twitchemotes.com/api/v4/sets\",
			searchParams: \"id=\" + emoteSets.join(\",\"),
			responseType: \"json\"
		});

		if (statusCode !== 200) {
			throw new sb.errors.APIError({
				statusCode,
				apiName: \"TwitchEmotesAPI\"
			});
		}

		this.data.fetched = new sb.Date();
		this.data.emoteSets = body.map(i => i.set_id).sort();
		this.data.emoteSetsData = body;
	}

	const result = [];
	for (const set of controller.availableEmoteSets) {
		const setData = this.data.emoteSetsData.find(i => i.set_id === set);
		const emoteList = controller.availableEmotes[set];
		if (!emoteList || !setData || setData.channel_name === \"Twitch\") {
			continue;
		}

		const tier = (setData.tier !== 1) ? ` (T${setData.tier})` : \"\";
		result.push({
			channel: `${setData.channel_name}${tier}`,
			emote: sb.Utils.randArray(emoteList).code
		});
	}

	result.sort((a, b) => a.channel.localeCompare(b.channel));

	const channels = result.map(i => `#${i.channel}`);
	const emotes = result.map(i => i.emote);
	return {
		reply: \"Supibot is currently subbed to: \" + channels.join(\", \") + \" \" + emotes.join(\" \")
	};
})',
		NULL,
		'supinic/supibot-sql'
	)