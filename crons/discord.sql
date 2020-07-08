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
		7,
		'discord',
		'0 0 */2 * * *',
		'Posts the discord link of supinic channel',
		'(async function announceDiscordLink () {
	const channelData = sb.Channel.get(\"supinic\", \"twitch\");
	if (!channelData.sessionData.live) {
		await channelData.send(channelData.Data.discord);
	}
})',
		'Bot',
		1
	)