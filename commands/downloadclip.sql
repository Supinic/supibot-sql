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
		148,
		'downloadclip',
		'[\"dlclip\"]',
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
		0,
		NULL,
		'(async function downloadClip (context, rawSlug) {
	if (!rawSlug) {
		return { reply: \"No clip slug provided!\" };
	}

	const slug = rawSlug.match(/[a-zA-z]+$/)[0];
	const data = await sb.Got.instances.Leppunen(`twitch/clip/${slug}`).json();	
	if (data.status === 404) {
		return {
			reply: \"No data found for given slug!\"
		};
	}

	const source = Object.entries(data.response.videoQualities).sort((a, b) => Number(a.quality) - Number(b.quality))[0][1].sourceURL;
	return {
		replyWithPrivateMessage: true,
		reply: source
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function downloadClip (context, rawSlug) {
	if (!rawSlug) {
		return { reply: \"No clip slug provided!\" };
	}

	const slug = rawSlug.match(/[a-zA-z]+$/)[0];
	const data = await sb.Got.instances.Leppunen(`twitch/clip/${slug}`).json();	
	if (data.status === 404) {
		return {
			reply: \"No data found for given slug!\"
		};
	}

	const source = Object.entries(data.response.videoQualities).sort((a, b) => Number(a.quality) - Number(b.quality))[0][1].sourceURL;
	return {
		replyWithPrivateMessage: true,
		reply: source
	};
})'