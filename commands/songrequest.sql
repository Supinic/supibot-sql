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
		56,
		'songrequest',
		'[\"sr\"]',
		'Requests a song to play on supinic stream. Uses a local VLC API to enqueue songs to the playlist, or links to Cytube, or uses the necrodancer command to download a song. This all depends on the song request status.',
		5000,
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
		'({
	videoLimit: 5
})',
		'(async function songRequest (context, ...args) {
	const state = sb.Config.get(\"SONG_REQUESTS_STATE\");
	if (state === \"off\") {
		return { reply: \"Song requests are currently turned off.\" };
	}
	else if (state === \"dubtrack\") {
		const dubtrack = (await sb.Command.get(\"dubtrack\").execute(context)).reply;
		return { reply: \"Song requests are currently using dubtrack. Join here: \" + dubtrack + \" :)\" };
	}
	else if (state === \"cytube\") {
		const cytube = (await sb.Command.get(\"cytube\").execute(context)).reply;
		return { reply: \"Song requests are currently using Cytube. Join here: \" + cytube + \" :)\" };
	}
	else if (args.length === 0) {
		return { reply: \"You must search for a link or a video description!\" };
	}

	const currentData = await sb.VideoLANConnector.currentlyPlayingData();
	if (currentData) {
		const userRequests = sb.VideoLANConnector.videoQueue.filter(i => i.vlcID >= currentData.vlcID && i.user === context.user.ID).length;
		if (userRequests >= this.staticData.videoLimit) {
			return {
				reply: `Can only request up to ${this.staticData.videoLimit} videos in the queue!`
			}
		}
	}

	const url = args.join(\" \");
	const parsedURL = require(\"url\").parse(url);

	if (parsedURL.host === \"supinic.com\" && parsedURL.path.includes(\"/track/detail\")) {
		const songID = Number(parsedURL.path.match(/(\\d+)/)[1]);
		if (!songID) {
			return { reply: \"Invalid link!\" };
		}

		const songData = await sb.Query.getRecordset(rs => rs
			.select(\"Link\", \"Name\", \"Duration\")
			.select(\"Video_Type.Link_Prefix AS Prefix\")
			.from(\"music\", \"Track\")
			.join(\"data\", \"Video_Type\")
			.where(\"Track.ID = %n\", songID)
			.single()
		);

		if (!songData) {
			return { reply: \"Track does not exist in the list!\" };
		}
		else {
			const videoTypePrefix = sb.Config.get(\"VIDEO_TYPE_REPLACE_PREFIX\");
			const link = songData.Prefix.replace(videoTypePrefix, songData.Link);
			const id = await sb.VideoLANConnector.add(link, context.user.ID, {
				length: songData.Duration,
				name: songData.Name
			});

			return {
				reply: `Video \"${songData.Name}\" from supinic.com successfully added to queue with ID ${id}!`
			};
		}
	}
	else if (parsedURL.host) {
		const data = await sb.Got({
			url,
			method: \"HEAD\",
			throwHttpErrors: false
		});

		let passed = false;
		if (data.statusCode === 200) {
			const type = data.headers[\"content-type\"];
			passed = type.startsWith(\"audio/\") || type.startsWith(\"video/\");
		}
		else {
			passed = url.endsWith(\".mp3\") || url.endsWith(\".mp4\") || url.endsWith(\".ogg\");
		}

		if (passed) {
			try {
				const id = await sb.VideoLANConnector.add(url, context.user.ID, {name: url});
				return {
					reply: \"Your custom link request has been added to the queue with ID \" + id
				};
			}
			catch (e) {
				console.error(e);
				return {
					reply: \"VLC is not responding (probably not running or sr\'s are off), no link has been added!\"
				};
			}
		}
	}

	let data = null;
	try {
		data = await sb.Utils.linkParser.fetchData(url);
	}
	catch {
		data = null;
	}

	if (!data) {
		const lookup = await sb.Utils.fetchYoutubeVideo(
			args.join(\" \").replace(/-/g, \"\"),
			sb.Config.get(\"API_GOOGLE_YOUTUBE\")
		);

		if (!lookup) {
			return {
				reply: \"No video matching that query has been found.\"
			};
		}
		else {
			data = await sb.Utils.linkParser.fetchData(lookup.link);
		}
	}

	const limit = sb.Config.get(\"MAX_SONG_REQUEST_LENGTH\");
	const length = data.duration || data.length;
	if (length > limit) {
		return {
			reply: `Video \"${data.name}\" by ${data.author} is too long: ${length}s > ${limit}s`
		};
	}
	else {
		let id = null;
		try {
			id = await sb.VideoLANConnector.add(data.link, context.user.ID, data);
		}
		catch {
			await sb.Config.set(\"SONG_REQUESTS_STATE\", \"off\");
			return {
				reply: `The desktop listener is currently turned off. Turning song requests off.`
			};
		}

		let when = \"right now!\";
		const status = await sb.VideoLANConnector.status();

		if (status.currentplid !== -1 && status.currentplid !== id && status.time !== 0) {
			const { vlcID: nowID } = await sb.VideoLANConnector.currentlyPlayingData();
			const { time, length } = status;

			const playingDate = new sb.Date().addSeconds(length - time);
			const inQueue = sb.VideoLANConnector.videoQueue.filter(i => i.vlcID > nowID);
			for (const { length } of inQueue) {
				playingDate.addSeconds(length ?? 0);
			}

			when = sb.Utils.timeDelta(playingDate);
		}

		const row = await sb.Query.getRow(\"chat_data\", \"Song_Request\");
		row.setValues({
			Link: data.ID,
			Video_Type: 1,
			Status: null,
			User_Alias: context.user.ID,
		});
		await row.save();

		return {
			reply: `Video \"${data.name}\" by ${data.author} successfully added to queue with ID ${id}! It is playing ${when}`
		};
	}
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function songRequest (context, ...args) {
	const state = sb.Config.get(\"SONG_REQUESTS_STATE\");
	if (state === \"off\") {
		return { reply: \"Song requests are currently turned off.\" };
	}
	else if (state === \"dubtrack\") {
		const dubtrack = (await sb.Command.get(\"dubtrack\").execute(context)).reply;
		return { reply: \"Song requests are currently using dubtrack. Join here: \" + dubtrack + \" :)\" };
	}
	else if (state === \"cytube\") {
		const cytube = (await sb.Command.get(\"cytube\").execute(context)).reply;
		return { reply: \"Song requests are currently using Cytube. Join here: \" + cytube + \" :)\" };
	}
	else if (args.length === 0) {
		return { reply: \"You must search for a link or a video description!\" };
	}

	const currentData = await sb.VideoLANConnector.currentlyPlayingData();
	if (currentData) {
		const userRequests = sb.VideoLANConnector.videoQueue.filter(i => i.vlcID >= currentData.vlcID && i.user === context.user.ID).length;
		if (userRequests >= this.staticData.videoLimit) {
			return {
				reply: `Can only request up to ${this.staticData.videoLimit} videos in the queue!`
			}
		}
	}

	const url = args.join(\" \");
	const parsedURL = require(\"url\").parse(url);

	if (parsedURL.host === \"supinic.com\" && parsedURL.path.includes(\"/track/detail\")) {
		const songID = Number(parsedURL.path.match(/(\\d+)/)[1]);
		if (!songID) {
			return { reply: \"Invalid link!\" };
		}

		const songData = await sb.Query.getRecordset(rs => rs
			.select(\"Link\", \"Name\", \"Duration\")
			.select(\"Video_Type.Link_Prefix AS Prefix\")
			.from(\"music\", \"Track\")
			.join(\"data\", \"Video_Type\")
			.where(\"Track.ID = %n\", songID)
			.single()
		);

		if (!songData) {
			return { reply: \"Track does not exist in the list!\" };
		}
		else {
			const videoTypePrefix = sb.Config.get(\"VIDEO_TYPE_REPLACE_PREFIX\");
			const link = songData.Prefix.replace(videoTypePrefix, songData.Link);
			const id = await sb.VideoLANConnector.add(link, context.user.ID, {
				length: songData.Duration,
				name: songData.Name
			});

			return {
				reply: `Video \"${songData.Name}\" from supinic.com successfully added to queue with ID ${id}!`
			};
		}
	}
	else if (parsedURL.host) {
		const data = await sb.Got({
			url,
			method: \"HEAD\",
			throwHttpErrors: false
		});

		let passed = false;
		if (data.statusCode === 200) {
			const type = data.headers[\"content-type\"];
			passed = type.startsWith(\"audio/\") || type.startsWith(\"video/\");
		}
		else {
			passed = url.endsWith(\".mp3\") || url.endsWith(\".mp4\") || url.endsWith(\".ogg\");
		}

		if (passed) {
			try {
				const id = await sb.VideoLANConnector.add(url, context.user.ID, {name: url});
				return {
					reply: \"Your custom link request has been added to the queue with ID \" + id
				};
			}
			catch (e) {
				console.error(e);
				return {
					reply: \"VLC is not responding (probably not running or sr\'s are off), no link has been added!\"
				};
			}
		}
	}

	let data = null;
	try {
		data = await sb.Utils.linkParser.fetchData(url);
	}
	catch {
		data = null;
	}

	if (!data) {
		const lookup = await sb.Utils.fetchYoutubeVideo(
			args.join(\" \").replace(/-/g, \"\"),
			sb.Config.get(\"API_GOOGLE_YOUTUBE\")
		);

		if (!lookup) {
			return {
				reply: \"No video matching that query has been found.\"
			};
		}
		else {
			data = await sb.Utils.linkParser.fetchData(lookup.link);
		}
	}

	const limit = sb.Config.get(\"MAX_SONG_REQUEST_LENGTH\");
	const length = data.duration || data.length;
	if (length > limit) {
		return {
			reply: `Video \"${data.name}\" by ${data.author} is too long: ${length}s > ${limit}s`
		};
	}
	else {
		let id = null;
		try {
			id = await sb.VideoLANConnector.add(data.link, context.user.ID, data);
		}
		catch {
			await sb.Config.set(\"SONG_REQUESTS_STATE\", \"off\");
			return {
				reply: `The desktop listener is currently turned off. Turning song requests off.`
			};
		}

		let when = \"right now!\";
		const status = await sb.VideoLANConnector.status();

		if (status.currentplid !== -1 && status.currentplid !== id && status.time !== 0) {
			const { vlcID: nowID } = await sb.VideoLANConnector.currentlyPlayingData();
			const { time, length } = status;

			const playingDate = new sb.Date().addSeconds(length - time);
			const inQueue = sb.VideoLANConnector.videoQueue.filter(i => i.vlcID > nowID);
			for (const { length } of inQueue) {
				playingDate.addSeconds(length ?? 0);
			}

			when = sb.Utils.timeDelta(playingDate);
		}

		const row = await sb.Query.getRow(\"chat_data\", \"Song_Request\");
		row.setValues({
			Link: data.ID,
			Video_Type: 1,
			Status: null,
			User_Alias: context.user.ID,
		});
		await row.save();

		return {
			reply: `Video \"${data.name}\" by ${data.author} successfully added to queue with ID ${id}! It is playing ${when}`
		};
	}
})'