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
		21,
		'posture-check',
		'0 50 * * * *',
		'Check your posture!',
		NULL,
		'(async function announceStayHydrated () {
	const channelData = sb.Channel.get(\"supinic\", \"twitch\");
	if (channelData.sessionData.live) {
		await channelData.send(\"monkaS 👆 Check your posture chat\");
	}
})',
		'Bot',
		1
	)