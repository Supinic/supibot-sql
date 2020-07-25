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
		232,
		'randomuploadervideo',
		'[\"ruv\"]',
		'mention,pipe',
		'On supinic\'s stream, takes the currently playing video (if there is any) and fetches another random video from the same Youtube uploader.',
		20000,
		'Only usable in Supinic\'s channel.',
		NULL,
		'(async function randomUploaderVideo (context, ...args) {
	let linkOnly = false;
	for (let i = args.length - 1; i >= 0; i--) {
		const token = args[i];
		if (token.startsWith(\"linkOnly\")) {
			linkOnly = token.split(\":\")[1] === \"true\";
			args.splice(i, 1);
		}
	}

	const link = args.shift();
	if (!link) {
		return {
			success: false,
			reply: `No link provided!`
		};
	}

	const type = sb.Utils.linkParser.autoRecognize(link);
	if (type === null) {
		return {
			success: false,
			reply: `Provided link was not recognized!`
		};
	}
	else if (type !== \"youtube\") {
		return {
			success: false,
			reply: `Provided link is not located on YouTube - cannot continue!`
		};
	}

	const linkData = await sb.Utils.linkParser.fetchData(link);
	if (!linkData) {
		return {
			success: false,
			reply: `Provided video is not available!`
		};
	}

	const authorData = await sb.Got({
		throwHttpErrors: false,
		responseType: \"json\",
		url: \"https://www.googleapis.com/youtube/v3/channels\",
		searchParams: new sb.URLParams()
			.set(\"part\", \"contentDetails,snippet\")
			.set(\"id\", linkData.authorID)
			.set(\"key\", sb.Config.get(\"API_GOOGLE_YOUTUBE\"))
			.toString()
	}).json();

	const playlistID = authorData?.items?.[0]?.contentDetails?.relatedPlaylists?.uploads;
	if (!playlistID) {
		return {
			success: false,
			reply: `No uploads playlist found!`
		};
	}

	const { result } = await sb.Utils.fetchYoutubePlaylist({
		key: sb.Config.get(\"API_GOOGLE_YOUTUBE\"),
		limit: 50,
		limitAction: null,
		perPage: 50,
		playlistID
	});
	const playlistData = result.filter(i => i.ID !== linkData.ID);
	if (playlistData.length === 0) {
		return {
			success: false,
			reply: `There are no other videos from this uploader!`
		};
	}

	const authorName = authorData?.items?.[0]?.snippet?.title ?? \"(unknown)\";
	const prettyString = (linkOnly)
		? \"\"
		: `Random video from ${authorName}:`;

	const { ID } = sb.Utils.randArray(playlistData);
	return {
		reply: `${prettyString} https://youtu.be/${ID}`
	};
})',
		NULL,
		'supinic/supibot-sql'
	)