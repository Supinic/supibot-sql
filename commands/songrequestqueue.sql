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
		161,
		'songrequestqueue',
		'[\"srq\", \"queue\"]',
		'Posts the summary of song request queue. EXPERIMENTAL monkaS',
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
		'(async function songRequestQueue () {
	const state = sb.Config.get(\"SONG_REQUESTS_STATE\");
	if (state === \"off\") {
		return { reply: \"Song requests are currently turned off.\" };
	}
	else if (state === \"dubtrack\") {
		const dubtrack = (await sb.Command.get(\"dubtrack\").execute(context)).reply;
		return { reply: \"Song requests are currently using dubtrack. Join here: \" + dubtrack + \" :)\" };
	}

	const status = await sb.VideoLANConnector.status(); 
	const url = (status.information.category.meta.url.includes(\".mp3\"))
		? status.information.category.meta.url
		: sb.Utils.linkParser.parseLink(status.information.category.meta.url);

	const firstSongIndex = sb.VideoLANConnector.videoQueue.findIndex(i => {
		if (i.link.includes(\".mp3\")) {
			return i.link === url;
		}
		else {
			return sb.Utils.linkParser.parseLink(i.link) === url;
		}
	});

	if (firstSongIndex === -1) {
		return { reply: \"No song data found!\" };
	}

	const playlist = sb.VideoLANConnector.videoQueue.slice(firstSongIndex);
	const length = playlist.reduce((acc, cur) => acc += cur.length || 0, 0);
	const delta = sb.Utils.timeDelta(sb.Date.now() + length * 1000, true);

	return {
		reply: `There are ${playlist.length} videos in the queue, with a total length of ${delta}. Check it out here: https://supinic.com/stream/video-queue`
	}
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function songRequestQueue () {
	const state = sb.Config.get(\"SONG_REQUESTS_STATE\");
	if (state === \"off\") {
		return { reply: \"Song requests are currently turned off.\" };
	}
	else if (state === \"dubtrack\") {
		const dubtrack = (await sb.Command.get(\"dubtrack\").execute(context)).reply;
		return { reply: \"Song requests are currently using dubtrack. Join here: \" + dubtrack + \" :)\" };
	}

	const status = await sb.VideoLANConnector.status(); 
	const url = (status.information.category.meta.url.includes(\".mp3\"))
		? status.information.category.meta.url
		: sb.Utils.linkParser.parseLink(status.information.category.meta.url);

	const firstSongIndex = sb.VideoLANConnector.videoQueue.findIndex(i => {
		if (i.link.includes(\".mp3\")) {
			return i.link === url;
		}
		else {
			return sb.Utils.linkParser.parseLink(i.link) === url;
		}
	});

	if (firstSongIndex === -1) {
		return { reply: \"No song data found!\" };
	}

	const playlist = sb.VideoLANConnector.videoQueue.slice(firstSongIndex);
	const length = playlist.reduce((acc, cur) => acc += cur.length || 0, 0);
	const delta = sb.Utils.timeDelta(sb.Date.now() + length * 1000, true);

	return {
		reply: `There are ${playlist.length} videos in the queue, with a total length of ${delta}. Check it out here: https://supinic.com/stream/video-queue`
	}
})'