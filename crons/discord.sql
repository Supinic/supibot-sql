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
		'(async function cron_discord () {
	const channelData = sb.Channel.get(38);
	if (!channelData.sessionData.live) {
		sb.Master.send(
			\"Check out the Hackerman Club on Discord - now with subscriber emotes! https://discord.gg/wHWjRzp\",
			channelData
		);
	}
})',
		'Bot',
		1
	)