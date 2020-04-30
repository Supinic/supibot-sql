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
		5,
		'github',
		'0 0 1-23/2 * * *',
		'Posts the github link of supibot.',
		'(async function cron_discord () {
	const channelData = sb.Channel.get(38);
	if (!channelData.sessionData.live) {
		sb.Master.send(
			\"Node.JS developers miniDank check the Supibot repository miniDank 👉 https://github.com/Supinic/supibot\",
			channelData
		);
	}
})',
		'Bot',
		1
	)