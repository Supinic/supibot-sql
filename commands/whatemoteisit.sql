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
		Static_Data,
		Code,
		Examples,
		Dynamic_Description
	)
VALUES
	(
		122,
		'whatemoteisit',
		'[\"weit\"]',
		'What emote is it? Posts specifics about a given Twitch subscriber emote.',
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
		NULL,
		'(async function whatEmoteIsIt (context, emote) {
	const data = await sb.Got.instances.Leppunen(\"twitch/emotes/\" + emote).json();
	const {error, channel, channelid, emoteid, emotecode, tier} = data;
	if (error) {
		return { reply: error + \"!\" };
	}

	const channelLink = \"https://twitchemotes.com/channels/\" + channelid;
	return {
		reply: `${emotecode} (ID ${emoteid}) - ${channelLink} (ID ${channelid}) tier ${tier} sub emote`
	}
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function whatEmoteIsIt (context, emote) {
	const data = await sb.Got.instances.Leppunen(\"twitch/emotes/\" + emote).json();
	const {error, channel, channelid, emoteid, emotecode, tier} = data;
	if (error) {
		return { reply: error + \"!\" };
	}

	const channelLink = \"https://twitchemotes.com/channels/\" + channelid;
	return {
		reply: `${emotecode} (ID ${emoteid}) - ${channelLink} (ID ${channelid}) tier ${tier} sub emote`
	}
})'