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
		122,
		'whatemoteisit',
		'[\"weit\"]',
		'mention,pipe',
		'What emote is it? Posts specifics about a given Twitch subscriber emote.',
		10000,
		NULL,
		NULL,
		'(async function whatEmoteIsIt (context, emote) {
	const data = await sb.Got.instances.Leppunen(\"twitch/emotes/\" + emote).json();
	const {error, channel, channelid, emoteid, emotecode, tier} = data;
	if (error) {
		return { reply: error + \"!\" };
	}

	const originID = await sb.Query.getRecordset(rs => rs
	    .select(\"ID\")
	    .from(\"data\", \"Origin\")
		.where(\"Emote_ID = %s\", emoteid)
		.limit(1)
		.single()
		.flat(\"ID\")
	);

	const emoteLink = \"https://twitchemotes.com/emotes/\" + emoteid;
	const originString = (originID)
		? `This emote has origin info - use the ${sb.Command.prefix}origin command.`
		: \"\";

	return {
		reply: (channel)
			? `${emotecode} (ID ${emoteid}) - tier ${tier} sub emote to channel #${channel.toLowerCase()}. ${emoteLink} ${originString}`
			: `${emotecode} (ID ${emoteid}) - global Twitch emote. ${emoteLink} ${originString}`
	};

})',
		NULL,
		'supinic/supibot-sql'
	)