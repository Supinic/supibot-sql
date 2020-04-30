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
		12,
		'twitch-online-channels',
		'0 */2 * * * *',
		'Fetches the online status of all active Twitch channels. Basically, just caches the current status so that further API calls are not necessary.',
		'(async function cron_twitchOnlineChannels () {
	const channelList = sb.Channel.getJoinableForPlatform(\"twitch\").filter(i => i.Mode !== \"Read\");
	const data = await sb.Got.instances.Twitch.Kraken({
		url: \"streams\",
		searchParams: \"channel=\" + channelList.map(i => i.Specific_ID).filter(Boolean).join(\",\")
	}).json();

	for (const channel of channelList) {
		channel.sessionData = channel.sessionData ?? {};
		channel.sessionData.live = false;
		channel.sessionData.stream = {};
	}

	const platform = sb.Platform.get(\"twitch\");
	for (const stream of data.streams) {
		const channelData = sb.Channel.get(stream.channel.name, platform);
		if (!channelData) {
			continue;
		}

		channelData.sessionData.live = true;
		channelData.sessionData.stream = {
			game: stream.game,
			since: new sb.Date(stream.created_at),
			status: stream.channel.status,
			viewers: stream.viewers,
			quality: stream.video_height + \"p\",
			fps: stream.average_fps,
			delay: stream.delay
		};
	}
})  ',
		'Bot',
		1
	)