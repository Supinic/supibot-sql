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
		161,
		'songrequestqueue',
		'[\"srq\", \"queue\"]',
		NULL,
		'Posts the summary of song request queue. EXPERIMENTAL monkaS',
		30000,
		0,
		0,
		0,
		1,
		'Only available in supinic\'s channel.',
		0,
		0,
		0,
		1,
		1,
		0,
		0,
		'({
	isCustom: (string) => (string.endsWith(\".mp3\") || string.endsWith(\".ogg\") || string.endsWith(\".mp4\"))
})',
		'(async function songRequestQueue (context) {
	const state = sb.Config.get(\"SONG_REQUESTS_STATE\");
	if (state === \"off\") {
		return { 
			reply: \"Song requests are currently turned off.\" 
		};
	}
	else if (state === \"dubtrack\") {
		const dubtrack = (await sb.Command.get(\"dubtrack\").execute(context)).reply;
		return {
			reply: \"Song requests are currently using dubtrack. Join here: \" + dubtrack + \" :)\"
		};
	}
	else if (state === \"cytube\") {
		const cytube = (await sb.Command.get(\"cytube\").execute(context)).reply;
		return { 
			reply: \"Song requests are currently using Cytube. Join here: \" + cytube + \" :)\"
		};
	}

	const data = await sb.Query.getRecordset(rs => rs
		.select(\"COUNT(*) AS Count\", \"SUM(Length) AS Length\")
		.from(\"chat_data\", \"Song_Request\")
		.where(\"Status = %s OR Status = %s\", \"Current\", \"Queued\")
		.single()
	);

	if (data.Length === null) {
		return {
			reply: \"No songs are currently queued. Check history here: https://supinic.com/stream/song-request/history\"
		};
	}

	let status = null;
	try {
		status = await sb.VideoLANConnector.status(); 
	}
	catch (e) {
		if (e.message === \"ETIMEDOUT\") {
			return {
				reply: \"VLC is not available right now!\"
			};
		}
		else {
			throw e;
		}
	}

	const length = data.Length - status.time;
	const delta = sb.Utils.timeDelta(sb.Date.now() + length * 1000, true);

	return {
		reply: `There are ${data.Count} videos in the queue, with a total length of ${delta}. Check it out here: https://supinic.com/stream/song-request/queue`
	}
})',
		NULL,
		NULL
	)