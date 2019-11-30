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
		148,
		'dlclip',
		NULL,
		'Takes a Twitch clip name, and sends a download link to it into whispers.',
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
		'async (extra, rawSlug) => {
	if (!rawSlug) {
		return { reply: \"Pepega\" };
	}

	const slug = rawSlug.match(/[a-zA-z]+$/)[0];	
	const data = JSON.parse(await sb.Utils.request({
		url: `https://clips.twitch.tv/api/v1/clips/${slug}/status`,
		headers: {
			Accept: \"application/vnd.twitchtv.v5+json\",
			\"Client-ID\":  sb.Config.get(\"TWITCH_CLIENT_ID\")
		}
	}));

	if (!data) {
		return { reply: \"Pepega\" };
	}

	const source = Object.entries(data.quality_options).sort((a, b) => Number(a.quality) - Number(b.quality))[0][1].source;
	return {
		replyWithPrivateMessage: true,
		reply: source
	};
}',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async (extra, rawSlug) => {
	if (!rawSlug) {
		return { reply: \"Pepega\" };
	}

	const slug = rawSlug.match(/[a-zA-z]+$/)[0];	
	const data = JSON.parse(await sb.Utils.request({
		url: `https://clips.twitch.tv/api/v1/clips/${slug}/status`,
		headers: {
			Accept: \"application/vnd.twitchtv.v5+json\",
			\"Client-ID\":  sb.Config.get(\"TWITCH_CLIENT_ID\")
		}
	}));

	if (!data) {
		return { reply: \"Pepega\" };
	}

	const source = Object.entries(data.quality_options).sort((a, b) => Number(a.quality) - Number(b.quality))[0][1].source;
	return {
		replyWithPrivateMessage: true,
		reply: source
	};
}'