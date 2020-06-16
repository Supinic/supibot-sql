INSERT INTO
	`chat_data`.`Command`
	(
		ID,
		Name,
		Aliases,
		Flags,
		Description,
		Cooldown,
		Whitelist_Response,
		Static_Data,
		Code,
		Dynamic_Description,
		Source
	)
VALUES
	(
		56,
		'songrequest',
		'[\"sr\"]',
		'ping,pipe,whitelist',
		'Requests a song to play on Supinic\'s stream. You can use \"start:\" and \"end:\" to request parts of a song using seconds or a time syntax. \"start:100\" or \"end:05:30\", for example.',
		5000,
		'Only available in supinic\'s channel.',
		'({
	limit: 605,
	emptyQueueLimit: 905,
	videoLimit: 5,
	blacklistedSites: [
		\"grabify.link\",
		\"leancoding.co\",
		\"stopify.co\",
		\"freegiftcards.co\",
		\"joinmy.site\",
		\"curiouscat.club\",
		\"catsnthings.fun\",
		\"catsnthing.com\",
		\"iplogger.org\",
		\"2no.co\",
		\"iplogger.com\",	
		\"iplogger.ru\",
		\"yip.su\",
		\"iplogger.co\",
		\"iplogger.info\",
		\"ipgrabber.ru\",
		\"ipgraber.ru\",
		\"iplis.ru\",
		\"02ip.ru\",
		\"ezstat.ru\"
	],
	parseTimestamp: (string) => {
		const type = sb.Utils.linkParser.autoRecognize(string);
		if (type === \"youtube\" && string.includes(\"t=\")) {
			const { parse } = require(\"url\");
			let { query } = parse(string);

			if (/t=\\d+/.test(query)) {
				query = query.replace(/(t=\\d+\\b)/, \"$1sec\");
			}

			return sb.Utils.parseDuration(query, { target: \"sec\" });
		}
	}
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

	const queue = await sb.VideoLANConnector.getNormalizedPlaylist();
	const userRequests = queue.filter(i => i.User_Alias === context.user.ID);
	if (userRequests.length >= this.staticData.videoLimit) {
		return {
			reply: `Can only request up to ${this.staticData.videoLimit} videos in the queue!`
		}
	}

	let startTime = null;
	let endTime = null;
	let type = \"youtube\";
	for (let i = args.length - 1; i >= 0; i--) {
		const token = args[i];
		if (token.includes(\"type:\")) {
			type = token.split(\":\")[1];
			args.splice(i, 1);
		}
		else if (token.includes(\"start:\")) {
			const string = token.split(\":\").slice(1).join(\":\");
			startTime = sb.Utils.parseVideoDuration(string);
			args.splice(i, 1);

			if (!Number.isFinite(startTime) || startTime <= 0 || startTime > Math.pow(2, 32)) {
				return {
					success: false,
					reply: \"Invalid start time!\"
				};
			}
		}
		else if (token.includes(\"end:\")) {
			const string = token.split(\":\").slice(1).join(\":\");
			endTime = sb.Utils.parseVideoDuration(string);
			args.splice(i, 1);

			if (!Number.isFinite(endTime) || endTime <= 0 || endTime > Math.pow(2, 32)) {
				return {
					success: false,
					reply: \"Invalid end time!\"
				};
			}
		}
	}

	let url = args.join(\" \");
	const potentialTimestamp = this.staticData.parseTimestamp(url);
	if (potentialTimestamp && startTime === null) {
		startTime = potentialTimestamp;
	}

	if (startTime !== null && endTime !== null && startTime > endTime) {
		return {
			success: false,
			reply: \"Start time cannot be greater than the end time!\"
		};
	}

	const parsedURL = require(\"url\").parse(url);
	let data = null;

	if (this.staticData.blacklistedSites.includes(parsedURL.host)) {
		return {
			success: false,
			reply: \"Don\'t.\"
		};
	}
	else if (parsedURL.host === \"supinic.com\" && parsedURL.path.includes(\"/track/detail\")) {
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

	if (sb.Utils.linkParser.autoRecognize(url)) {
		data = await sb.Utils.linkParser.fetchData(url);
	}
	else if (parsedURL.host) {
		const meta = await sb.Utils.getMediaFileData(url);
		if (meta?.duration) {
			const name = decodeURIComponent(parsedURL.path.split(\"/\").pop());
			const encoded = encodeURI(url);
			data = {
				name,
				ID: encoded,
				link: encoded,
				duration: meta.duration,
				videoType: { ID: 19 }
			};
		}
	}

	// If no data have been extracted from a link, attempt a search query on Youtube/Vimeo
	if (!data) {
		let lookup = null;
		if (type === \"vimeo\") {
			const { body, statusCode } = await sb.Got.instances.Vimeo({
				url: \"videos\",
				throwHttpErrors: false,
				searchParams: new sb.URLParams()
					.set(\"query\", args.join(\" \"))
					.set(\"per_page\", \"1\")
					.set(\"sort\", \"relevant\")
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
				lookup = { link: body.data[0].link };
			}
		}
		else if (type === \"youtube\") {
			const data = await sb.Utils.searchYoutube(
				args.join(\" \").replace(/-/g, \"\"),
				sb.Config.get(\"API_GOOGLE_YOUTUBE\")
			);

			lookup = (data[0])
				? { link: data[0].ID }
				: null;
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
			data = await sb.Utils.linkParser.fetchData(lookup.link, type);
		}
	}

	const limit = (queue.length === 0)
		? this.staticData.emptyQueueLimit
		: this.staticData.limit;

	const authorString = (data.author) ? ` by ${data.author}` : \"\";
	const length = data.duration ?? data.length ?? null;
	const checkLength = (startTime === null && endTime === null)
		? length
		: ((endTime ?? length) - (startTime ?? 0));

	if (checkLength !== null && checkLength > limit) {
		return {
			reply: `Video \"${data.name}\"${authorString} is too long: ${checkLength}s > ${limit}s. However, you can change the start and end points of the video with these arguments, e.g.: start:20 end:60`
		};
	}
	else {
		let id = null;
		try {
			id = await sb.VideoLANConnector.add(data.link, { startTime, endTime });
		}
		catch (e) {
			console.warn(\"sr error\", e);
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
			const current = queue.find(i => i.Status === \"Current\");
			const { time: currentVideoPosition, length } = status;
			const endTime = current?.End_Time ?? length;

			const playingDate = new sb.Date().addSeconds(endTime - currentVideoPosition);
			const inQueue = queue.filter(i => i.Status === \"Queued\");

			for (const { Duration: length } of inQueue) {
				playingDate.addSeconds(length ?? 0);
			}

			started = null;
			videoStatus = \"Queued\";
			when = sb.Utils.timeDelta(playingDate);
		}

		const videoType = data.videoType ?? await sb.Query.getRecordset(rs => rs
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
			Length: (data.duration) ? Math.ceil(data.duration) : null,
			Status: videoStatus,
			Started: started,
			User_Alias: context.user.ID,
			Start_Time: startTime ?? null,
			End_Time: endTime ?? null
		});
		await row.save();

		const seek = [];
		if (startTime !== null) {
			seek.push(`starting at ${startTime} seconds`);
		}
		if (endTime !== null) {
			seek.push(`ending at ${endTime} seconds`);
		}

		const seekString = (seek.length > 0)
			? `Your video is ${seek.join(\" and \")}.`
			: \"\";

		return {
			reply: `Video \"${data.name}\"${authorString} successfully added to queue with ID ${id}! It is playing ${when}. ${seekString}`
		};
	}
})',
		NULL,
		'supinic/supibot-sql'
	)