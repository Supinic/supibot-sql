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
		'*/10 * * * * *',
		'Makes sure that there is not a prolonged period of song request silence on Supinic\'s stream while live.',
		NULL,
		'(async function preventStreamSilence () {
	if (this.data.stopped) {
		return;
	}

	const channelData = sb.Channel.get(\"supinic\", \"twitch\");
	if (!channelData.sessionData.live) {
		return;
	}

	const state = sb.Config.get(\"SONG_REQUESTS_STATE\");
	if (state !== \"vlc\") {
		return;
	}

	const queue = await sb.VideoLANConnector.getNormalizedPlaylist();
	if (queue.length !== 0) {
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

	const self = await sb.User.get(\"supibot\");
	const sr = sb.Command.get(\"sr\");
	const link = \"https://youtu.be/\" + sb.Utils.randArray(this.data.videos);

	const result = await sr.execute({ user: self, channel: channelData, platform: sb.Platform.get(1) }, link);
	await channelData.send(\"Silence prevention! \" + result.reply);
})',
		'Bot',
		1
	)