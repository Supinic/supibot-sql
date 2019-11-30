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
		'async (extra, emote) => {
	const url = \"https://api.ivr.fi/twitch/emotes/\" + emote;
	
	const {error, channel, channelid, emoteid, emotecode, tier} = JSON.parse(await sb.Utils.request(url, {
		headers: {
			\"User-Agent\": sb.Config.get(\"SUPIBOT_USER_AGENT\")
		}
	}));

	if (error) {
		return { reply: error + \"!\" };
	}

	const channelLink = \"https://twitchemotes.com/channels/\" + channelid;
	return {
		reply: `${emotecode} (ID ${emoteid}) - ${channelLink} (ID ${channelid}) tier ${tier} sub emote`
	}	
}',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async (extra, emote) => {
	const url = \"https://api.ivr.fi/twitch/emotes/\" + emote;
	
	const {error, channel, channelid, emoteid, emotecode, tier} = JSON.parse(await sb.Utils.request(url, {
		headers: {
			\"User-Agent\": sb.Config.get(\"SUPIBOT_USER_AGENT\")
		}
	}));

	if (error) {
		return { reply: error + \"!\" };
	}

	const channelLink = \"https://twitchemotes.com/channels/\" + channelid;
	return {
		reply: `${emotecode} (ID ${emoteid}) - ${channelLink} (ID ${channelid}) tier ${tier} sub emote`
	}	
}'