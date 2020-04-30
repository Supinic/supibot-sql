INSERT INTO
	`chat_data`.`Command`
	(
		ID,
		Name,
		Aliases,
		Flags,
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
		Owner_Override,
		Archived,
		Static_Data,
		Code,
		Examples,
		Dynamic_Description
	)
VALUES
	(
		126,
		'botsubs',
		NULL,
		NULL,
		'Checks the channels supibot is currently subscribed to on Twitch.',
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
		0,
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
		if (!setData || setData.channel_name === \"Twitch\") {
			continue;
		}

		const tier = (setData.tier !== 1) ? ` (T${setData.tier})` : \"\";
		result.push({
			channel: `${setData.channel_name}${tier}`,
			emote: sb.Utils.randArray(emoteList).code
		});
	}

	result.sort((a, b) => a.channel.localeCompare(b.channel));

	const channels = result.map(i => i.channel);
	const emotes = result.map(i => i.emote);
	return {
		reply: \"Supibot is currently subbed to: \" + channels.join(\", \") + \" \" + emotes.join(\" \")
	};
})',
		NULL,
		NULL
	)