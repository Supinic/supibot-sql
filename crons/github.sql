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
		'(async function announceGithub () {
	const channelData = sb.Channel.get(\"supinic\", \"twitch\");
	if (!channelData.sessionData.live) {
		await channelData.send(\"Node.JS developers peepoHackies check the Supibot repository miniDank 👉 https://github.com/Supinic/supibot\");
	}
})',
		'Bot',
		1
	)