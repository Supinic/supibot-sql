INSERT INTO
	`chat_data`.`Cron`
	(
		ID,
		Name,
		Expression,
		Description,
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

	const self = await sb.User.get(\"supibot\");
	const pipe = sb.Command.get(\"pipe\");

	const result = await pipe.execute({ user: self, channel: channelData, platform: sb.Platform.get(1) }, \"rg favourite:supinic | sr\");
	await channelData.send(\"Silence prevention! \" + result.reply);
})',
		'Bot',
		1
	)