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
		68,
		'current',
		'[\"song\"]',
		'Fetches the current song playing on stream.',
		5000,
		0,
		0,
		0,
		1,
		NULL,
		0,
		0,
		0,
		1,
		1,
		0,
		'(async function current (context) {
	const state = sb.Config.get(\"SONG_REQUESTS_STATE\");
	if (state === \"off\") {
		return { reply: \"Song requests are currently turned off.\" };
	}
	else if (state === \"dubtrack\") {
		return { reply: \"We are on Dubtrack, check ?song for the currently playing song :)\" };
	}
	else if (state === \"cytube\") {
		const playing = sb.Master.clients.cytube[0].currentlyPlaying;
		if (playing === null) {
			return {
				reply: \"Nothing is currently playing on Cytube.\"
			};
		}

		const media = playing.media;
		const prefix = (await sb.Query.getRecordset(rs => rs
			.select(\"Link_Prefix\")
			.from(\"data\", \"Video_Type\")
			.where(\"Type = %s\", media.type)
			.limit(1)
			.single()
		)).Link_Prefix;

		const requester = playing.user ?? playing.queueby ?? \"(unknown)\";
		const link = prefix.replace(\"$\", media.id);
		return {
			reply: `Currently playing on Cytube: ${media.title} ${link} (${media.duration}), queued by ${requester}`
		}
	}

	const song = await sb.VideoLANConnector.currentlyPlaying();
	if (song === null) {
		return { reply: \"No song is currently playing!\" };
	}
	else {
		const status = await sb.VideoLANConnector.status();

		let targetURL = null;
		let type = null;
		if (status.information.category.meta.url) {
			targetURL = sb.Utils.linkParser.parseLink(status.information.category.meta.url);
			type = \"link\";
		}
		else if (status.information.category.meta.filename) {
			targetURL = status.information.category.meta.filename;
			type = \"file\";
		}

		const extraData = sb.VideoLANConnector.videoQueue.find(songData => {
			if (type === \"file\") {
				return songData.link.includes(targetURL);
			}
			else {
				// This means the processed songData is a file, and is never the target if the looked up song is a link.
				if (songData.name === songData.link) {
					return false;
				}

				const songURL = sb.Utils.linkParser.parseLink(songData.link);
				return songURL === targetURL;
			}
		});

		if (!extraData) {
			return { reply: \"No song data found!\" };
		}

		const userData = await sb.User.get(extraData.user);
		if (!userData) {
			return { reply: \"No requester user data found\" };
		}

		const data = song.category.meta;
		if (!song.category.meta.title || !song.category.meta.url) {
			return {
				reply: `Currently playing: ${data.filename} (ID ${extraData.vlcID}) - current position: ${status.time}/${status.length}s - requested by ${userData.Name}`
			};
		}
		else {
			return {
				reply: `Currently playing: ${data.title} (ID ${extraData.vlcID}) - ${extraData.link} - current position: ${status.time}/${status.length}s - requested by ${userData.Name}`
			};
		}
	}
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function current (context) {
	const state = sb.Config.get(\"SONG_REQUESTS_STATE\");
	if (state === \"off\") {
		return { reply: \"Song requests are currently turned off.\" };
	}
	else if (state === \"dubtrack\") {
		return { reply: \"We are on Dubtrack, check ?song for the currently playing song :)\" };
	}
	else if (state === \"cytube\") {
		const playing = sb.Master.clients.cytube[0].currentlyPlaying;
		if (playing === null) {
			return {
				reply: \"Nothing is currently playing on Cytube.\"
			};
		}

		const media = playing.media;
		const prefix = (await sb.Query.getRecordset(rs => rs
			.select(\"Link_Prefix\")
			.from(\"data\", \"Video_Type\")
			.where(\"Type = %s\", media.type)
			.limit(1)
			.single()
		)).Link_Prefix;

		const requester = playing.user ?? playing.queueby ?? \"(unknown)\";
		const link = prefix.replace(\"$\", media.id);
		return {
			reply: `Currently playing on Cytube: ${media.title} ${link} (${media.duration}), queued by ${requester}`
		}
	}

	const song = await sb.VideoLANConnector.currentlyPlaying();
	if (song === null) {
		return { reply: \"No song is currently playing!\" };
	}
	else {
		const status = await sb.VideoLANConnector.status();

		let targetURL = null;
		let type = null;
		if (status.information.category.meta.url) {
			targetURL = sb.Utils.linkParser.parseLink(status.information.category.meta.url);
			type = \"link\";
		}
		else if (status.information.category.meta.filename) {
			targetURL = status.information.category.meta.filename;
			type = \"file\";
		}

		const extraData = sb.VideoLANConnector.videoQueue.find(songData => {
			if (type === \"file\") {
				return songData.link.includes(targetURL);
			}
			else {
				// This means the processed songData is a file, and is never the target if the looked up song is a link.
				if (songData.name === songData.link) {
					return false;
				}

				const songURL = sb.Utils.linkParser.parseLink(songData.link);
				return songURL === targetURL;
			}
		});

		if (!extraData) {
			return { reply: \"No song data found!\" };
		}

		const userData = await sb.User.get(extraData.user);
		if (!userData) {
			return { reply: \"No requester user data found\" };
		}

		const data = song.category.meta;
		if (!song.category.meta.title || !song.category.meta.url) {
			return {
				reply: `Currently playing: ${data.filename} (ID ${extraData.vlcID}) - current position: ${status.time}/${status.length}s - requested by ${userData.Name}`
			};
		}
		else {
			return {
				reply: `Currently playing: ${data.title} (ID ${extraData.vlcID}) - ${extraData.link} - current position: ${status.time}/${status.length}s - requested by ${userData.Name}`
			};
		}
	}
})'