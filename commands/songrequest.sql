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
		56,
		'songrequest',
		'[\"sr\"]',
		NULL,
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
		0,
		'({
	videoLimit: 5
})',
		'(async function songRequest (context, ...args) {
	const state = sb.Config.get(\"SONG_REQUESTS_STATE\");
	if (state === \"off\") {
		return { reply: \"Song requests are currently turned off.\" };
	}
	else if (state === \"vlc-read\") {
		return { reply: `Song requests are currently read-only. You can check what\'s playing with the \"current\" command, but not queue anything.` };
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

	const queue = await sb.Query.getRecordset(rs => rs
		.select(\"Length\", \"Status\", \"User_Alias\", \"VLC_ID\")
		.from(\"chat_data\", \"Song_Request\")
		.where(\"Status IN %s+\", [\"Current\", \"Queued\"])
	);

	const userRequests = queue.filter(i => i.User_Alias === context.user.ID);
	if (userRequests.length >= this.staticData.videoLimit) {
		return {
			reply: `Can only request up to ${this.staticData.videoLimit} videos in the queue!`
		}
	}

	let type = \"youtube\";
	for (let i = 0; i < args.length; i++) {
		const token = args[i];
		if (token.includes(\"type:\")) {
			type = token.split(\":\")[1];
			args.splice(i, 1);
		}
	}

	let url = args.join(\" \");
	const parsedURL = require(\"url\").parse(url);

	if (parsedURL.host === \"supinic.com\" && parsedURL.path.includes(\"/track/detail\")) {
		const videoTypePrefix = sb.Config.get(\"VIDEO_TYPE_REPLACE_PREFIX\");
		const songID = Number(parsedURL.path.match(/(\\d+)/)[1]);
		if (!songID) {
			return { reply: \"Invalid link!\" };
		}

		let songData = await sb.Query.getRecordset(rs => rs
			.select(\"Available\", \"Link\", \"Name\", \"Duration\")
			.select(\"Video_Type.Link_Prefix AS Prefix\")
			.from(\"music\", \"Track\")
			.join(\"data\", \"Video_Type\")
			.where(\"Track.ID = %n\", songID)
			.where(\"Available = %b\", true)
			.single()
		);

		if (!songData) {
			let targetID = null;
			const main = await sb.Query.getRecordset(rs => rs
				.select(\"Track.ID\", \"Available\", \"Link\", \"Name\", \"Duration\")
				.select(\"Video_Type.Link_Prefix AS Prefix\")
				.from(\"music\", \"Track\")
				.join(\"data\", \"Video_Type\")
				.join({
					toTable: \"Track_Relationship\",
					on: \"Track_Relationship.Track_To = Track.ID\"
				})
				.where(\"Relationship = %s\", \"Reupload of\")
				.where(\"Track_From = %n\", songID)
				.single()
			);

			targetID = main?.ID ?? songID;

			songData = await sb.Query.getRecordset(rs => rs
				.select(\"Track.ID\", \"Available\", \"Link\", \"Name\", \"Duration\")
				.select(\"Video_Type.Link_Prefix AS Prefix\")
				.from(\"music\", \"Track\")
				.join(\"data\", \"Video_Type\")
				.join({
					toTable: \"Track_Relationship\",
					on: \"Track_Relationship.Track_From = Track.ID\"
				})
				.where(\"Video_Type = %n\", 1)
				.where(\"Available = %b\", true)
				.where(\"Relationship IN %s+\", [\"Archive of\", \"Reupload of\"])
				.where(\"Track_To = %n\", targetID)
				.limit(1)
				.single()
			);

		}

		if (songData) {
			url = songData.Prefix.replace(videoTypePrefix, songData.Link);
		}
		else {
			url = null;
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
		let lookup = null;
		if (type === \"vimeo\") {
			const { body, statusCode } = await sb.Got.instances.Vimeo({
				url: \"videos\",
				throwHttpErrors: false,
				searchParams: new sb.URLParams()
					.set(\"query\", args.join(\" \"))
					.set(\"per_page\", \"1\")
					.set(\"sort\", \"relevance\")
					.set(\"direction\", \"desc\")
					.toString()
			});

			if (statusCode !== 200 || body.error) {
				return {
					success: false,
					reply: `Vimeo API returned error ${statusCode}: ${body.error}`
				};
			}
			else if (body.data.length > 0) {
				lookup = body.data[0].link;
			}
		}
		else if (type === \"youtube\") {
			lookup = await sb.Utils.fetchYoutubeVideo(
				args.join(\" \").replace(/-/g, \"\"),
				sb.Config.get(\"API_GOOGLE_YOUTUBE\")
			);
		}
		else {
			return {
				success: false,
				reply: \"Incorrect video search type provided!\"
			}
		}

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
		let videoStatus = \"Current\";
		let started = new sb.Date();
		const status = await sb.VideoLANConnector.status();

		if (queue.length > 0) {
			const { time, length } = status;
			const playingDate = new sb.Date().addSeconds(length - time);
			const inQueue = queue.filter(i => i.Status === \"Queued\");

			for (const { Length: length } of inQueue) {
				playingDate.addSeconds(length ?? 0);
			}

			started = null;
			videoStatus = \"Queued\";
			when = sb.Utils.timeDelta(playingDate);
		}

		const videoType = await sb.Query.getRecordset(rs => rs
			.select(\"ID\")
			.from(\"data\", \"Video_Type\")
			.where(\"Parser_Name = %s\", data.type)
			.limit(1)
			.single()
		);

		const row = await sb.Query.getRow(\"chat_data\", \"Song_Request\");
		row.setValues({
			VLC_ID: id,
			Link: data.ID,
			Name: sb.Utils.wrapString(data.name, 100),
			Video_Type: videoType.ID,
			Length: data.duration,
			Status: videoStatus,
			Started: started,
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
	else if (state === \"vlc-read\") {
		return { reply: `Song requests are currently read-only. You can check what\'s playing with the \"current\" command, but not queue anything.` };
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

	const queue = await sb.Query.getRecordset(rs => rs
		.select(\"Length\", \"Status\", \"User_Alias\", \"VLC_ID\")
		.from(\"chat_data\", \"Song_Request\")
		.where(\"Status IN %s+\", [\"Current\", \"Queued\"])
	);

	const userRequests = queue.filter(i => i.User_Alias === context.user.ID);
	if (userRequests.length >= this.staticData.videoLimit) {
		return {
			reply: `Can only request up to ${this.staticData.videoLimit} videos in the queue!`
		}
	}

	let type = \"youtube\";
	for (let i = 0; i < args.length; i++) {
		const token = args[i];
		if (token.includes(\"type:\")) {
			type = token.split(\":\")[1];
			args.splice(i, 1);
		}
	}

	let url = args.join(\" \");
	const parsedURL = require(\"url\").parse(url);

	if (parsedURL.host === \"supinic.com\" && parsedURL.path.includes(\"/track/detail\")) {
		const videoTypePrefix = sb.Config.get(\"VIDEO_TYPE_REPLACE_PREFIX\");
		const songID = Number(parsedURL.path.match(/(\\d+)/)[1]);
		if (!songID) {
			return { reply: \"Invalid link!\" };
		}

		let songData = await sb.Query.getRecordset(rs => rs
			.select(\"Available\", \"Link\", \"Name\", \"Duration\")
			.select(\"Video_Type.Link_Prefix AS Prefix\")
			.from(\"music\", \"Track\")
			.join(\"data\", \"Video_Type\")
			.where(\"Track.ID = %n\", songID)
			.where(\"Available = %b\", true)
			.single()
		);

		if (!songData) {
			let targetID = null;
			const main = await sb.Query.getRecordset(rs => rs
				.select(\"Track.ID\", \"Available\", \"Link\", \"Name\", \"Duration\")
				.select(\"Video_Type.Link_Prefix AS Prefix\")
				.from(\"music\", \"Track\")
				.join(\"data\", \"Video_Type\")
				.join({
					toTable: \"Track_Relationship\",
					on: \"Track_Relationship.Track_To = Track.ID\"
				})
				.where(\"Relationship = %s\", \"Reupload of\")
				.where(\"Track_From = %n\", songID)
				.single()
			);

			targetID = main?.ID ?? songID;

			songData = await sb.Query.getRecordset(rs => rs
				.select(\"Track.ID\", \"Available\", \"Link\", \"Name\", \"Duration\")
				.select(\"Video_Type.Link_Prefix AS Prefix\")
				.from(\"music\", \"Track\")
				.join(\"data\", \"Video_Type\")
				.join({
					toTable: \"Track_Relationship\",
					on: \"Track_Relationship.Track_From = Track.ID\"
				})
				.where(\"Video_Type = %n\", 1)
				.where(\"Available = %b\", true)
				.where(\"Relationship IN %s+\", [\"Archive of\", \"Reupload of\"])
				.where(\"Track_To = %n\", targetID)
				.limit(1)
				.single()
			);

		}

		if (songData) {
			url = songData.Prefix.replace(videoTypePrefix, songData.Link);
		}
		else {
			url = null;
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
		let lookup = null;
		if (type === \"vimeo\") {
			const { body, statusCode } = await sb.Got.instances.Vimeo({
				url: \"videos\",
				throwHttpErrors: false,
				searchParams: new sb.URLParams()
					.set(\"query\", args.join(\" \"))
					.set(\"per_page\", \"1\")
					.set(\"sort\", \"relevance\")
					.set(\"direction\", \"desc\")
					.toString()
			});

			if (statusCode !== 200 || body.error) {
				return {
					success: false,
					reply: `Vimeo API returned error ${statusCode}: ${body.error}`
				};
			}
			else if (body.data.length > 0) {
				lookup = body.data[0].link;
			}
		}
		else if (type === \"youtube\") {
			lookup = await sb.Utils.fetchYoutubeVideo(
				args.join(\" \").replace(/-/g, \"\"),
				sb.Config.get(\"API_GOOGLE_YOUTUBE\")
			);
		}
		else {
			return {
				success: false,
				reply: \"Incorrect video search type provided!\"
			}
		}

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
		let videoStatus = \"Current\";
		let started = new sb.Date();
		const status = await sb.VideoLANConnector.status();

		if (queue.length > 0) {
			const { time, length } = status;
			const playingDate = new sb.Date().addSeconds(length - time);
			const inQueue = queue.filter(i => i.Status === \"Queued\");

			for (const { Length: length } of inQueue) {
				playingDate.addSeconds(length ?? 0);
			}

			started = null;
			videoStatus = \"Queued\";
			when = sb.Utils.timeDelta(playingDate);
		}

		const videoType = await sb.Query.getRecordset(rs => rs
			.select(\"ID\")
			.from(\"data\", \"Video_Type\")
			.where(\"Parser_Name = %s\", data.type)
			.limit(1)
			.single()
		);

		const row = await sb.Query.getRow(\"chat_data\", \"Song_Request\");
		row.setValues({
			VLC_ID: id,
			Link: data.ID,
			Name: sb.Utils.wrapString(data.name, 100),
			Video_Type: videoType.ID,
			Length: data.duration,
			Status: videoStatus,
			Started: started,
			User_Alias: context.user.ID,
		});
		await row.save();

		return {
			reply: `Video \"${data.name}\" by ${data.author} successfully added to queue with ID ${id}! It is playing ${when}`
		};
	}
})'