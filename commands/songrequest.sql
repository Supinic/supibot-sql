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
		56,
		'songrequest',
		'[\"sr\"]',
		'Requests a song to play on supinic stream. Uses a local VLC API to enqueue songs to the playlist.',
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

	const url = args.join(\" \");
	const parsedURL = require(\"url\").parse(url);
	if (url.endsWith(\".mp3\")) {
		try {
			const id = await sb.VideoLANConnector.add(url, context.user.ID, {name: url});
			return { reply: \"Your custom link request has been added to the queue with ID \" + id };
		}
		catch (e) {
			console.error(e);
			return { reply: \"I guess not eShrug\" };
		}
	}
	else if (parsedURL.host === \"supinic.com\" && parsedURL.path.includes(\"/track/detail\")) {
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

	const params = new sb.URLParams().set(\"url\", url);
	const limit = sb.Config.get(\"MAX_SONG_REQUEST_LENGTH\");
	let data = JSON.parse(await sb.Utils.request(\"https://supinic.com/api/trackData/fetch?\" + params.toString())).data;

	if (!data) {
		data = await sb.Utils.fetchYoutubeVideo(args.join(\" \").replace(/-/g, \"\"), sb.Config.get(\"API_GOOGLE_YOUTUBE\"));
		if (!data) {
			return { reply: \"No video matching that query has been found.\" };
		}
	}

	if (state === \"necrodancer\") {
		const redirectCommand = sb.Command.get(\"necrodancer\");
		return await redirectCommand.execute(context, data.link);
	}

	const length = data.duration || data.length;
	if (length > limit) {
		return {
			reply: `Video \"${data.name}\" by ${data.author} is too long: ${length}s > ${limit}s`
		};
	}
	else {
		const id = await sb.VideoLANConnector.add(data.link, context.user.ID, data);
		return {
			reply: `Video \"${data.name}\" by ${data.author} successfully added to queue with ID ${id}!`
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

	const url = args.join(\" \");
	const parsedURL = require(\"url\").parse(url);
	if (url.endsWith(\".mp3\")) {
		try {
			const id = await sb.VideoLANConnector.add(url, context.user.ID, {name: url});
			return { reply: \"Your custom link request has been added to the queue with ID \" + id };
		}
		catch (e) {
			console.error(e);
			return { reply: \"I guess not eShrug\" };
		}
	}
	else if (parsedURL.host === \"supinic.com\" && parsedURL.path.includes(\"/track/detail\")) {
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

	const params = new sb.URLParams().set(\"url\", url);
	const limit = sb.Config.get(\"MAX_SONG_REQUEST_LENGTH\");
	let data = JSON.parse(await sb.Utils.request(\"https://supinic.com/api/trackData/fetch?\" + params.toString())).data;

	if (!data) {
		data = await sb.Utils.fetchYoutubeVideo(args.join(\" \").replace(/-/g, \"\"), sb.Config.get(\"API_GOOGLE_YOUTUBE\"));
		if (!data) {
			return { reply: \"No video matching that query has been found.\" };
		}
	}

	if (state === \"necrodancer\") {
		const redirectCommand = sb.Command.get(\"necrodancer\");
		return await redirectCommand.execute(context, data.link);
	}

	const length = data.duration || data.length;
	if (length > limit) {
		return {
			reply: `Video \"${data.name}\" by ${data.author} is too long: ${length}s > ${limit}s`
		};
	}
	else {
		const id = await sb.VideoLANConnector.add(data.link, context.user.ID, data);
		return {
			reply: `Video \"${data.name}\" by ${data.author} successfully added to queue with ID ${id}!`
		};
	}
})'