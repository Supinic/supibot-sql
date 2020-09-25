INSERT INTO
	`chat_data`.`Cron`
	(
		ID,
		Name,
		Expression,
		Description,
		Defer,
		Code,
		Type,
		Active
	)
VALUES
	(
		20,
		'stream-silence-prevention',
		'*/20 * * * * *',
		'Makes sure that there is not a prolonged period of song request silence on Supinic\'s stream while live.',
		NULL,
		'(async function preventStreamSilence () {
	if (this.data.stopped) {
		return;
	}

	const twitch = sb.Platform.get(\"twitch\");
	const cytube = sb.Platform.get(\"cytube\");
	const channelData = sb.Channel.get(\"supinic\", \"twitch\");
	if (!channelData.sessionData.live) {
		return;
	}

	const state = sb.Config.get(\"SONG_REQUESTS_STATE\");
	if (state !== \"vlc\" && state !== \"cytube\") {
		return;
	}

	let isQueueEmpty = null;
	if (state === \"vlc\") {
		const queue = await sb.VideoLANConnector.getNormalizedPlaylist();
		isQueueEmpty = (queue.length === 0);
	}
	else if (state === \"cytube\") {
		isQueueEmpty = (cytube.controller.playlistData.length === 0);
	}

	if (isQueueEmpty) {
		return;
	}

	if (!this.data.videos) {
		const playlistID = \"PL9TsqVDcBIdtyegewA00JC0mlSkoq-VnJ\";
		const { result } = await sb.Utils.fetchYoutubePlaylist({
			key: sb.Config.get(\"API_GOOGLE_YOUTUBE\"),
			playlistID
		});

		this.data.videos = result.map(i => i.ID);
	}

	let result = \"\";
	const videoID = sb.Utils.randArray(this.data.videos); 
	
	if (state === \"vlc\") {
		const link = \"https://youtu.be/\" + videoID;
		const self = await sb.User.get(\"supibot\");
		const sr = sb.Command.get(\"sr\");

		result = await sr.execute({ user: self, channel: channelData, platform: twitch }, link);
	}
	else if (state === \"cytube\") {
		await cytube.controller.queue(\"yt\", videoID);
		result = \"Silence prevention! Successfully added to Cytube (probably)\";
	}
	
	await channelData.send(result);
})',
		'Bot',
		1
	)