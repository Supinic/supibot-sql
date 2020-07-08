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
		8,
		'rejoin-twitch-channel',
		'0 0 * * * *',
		'Attempts to reconnect channels on Twitch that the bot has been unable to join - most likely because of a ban.',
		'(async function rejoinFailedTwitchChannels () {
	const { client, controller } = sb.Platform.get(\"twitch\");
	const channels = [...controller.failedJoinChannels];

	console.log(\"Attempting to re-join channels\", channels);

	await Promise.allSettled(channels.map(channel => client.join(channel)));
	controller.failedJoinChannels.clear();
})',
		'Bot',
		1
	)