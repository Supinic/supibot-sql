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

	const emoteLink = \"https://twitchemotes.com/emotes/\" + emoteid;
	return {
		reply: `${emotecode} (ID ${emoteid}) - tier ${tier} sub emote to channel ${channel}. ${emoteLink}`
	};
})',
		NULL,
		'supinic/supibot-sql'
	)