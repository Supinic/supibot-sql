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
		15,
		'stay-hydrated',
		'0 30 * * * *',
		'Stay hydrated!',
		'(async function announceStayHydrated () {
	const channelData = sb.Channel.get(\"supinic\", \"twitch\");
	if (channelData.sessionData.live) {
		await channelData.send(\"OMGScoots TeaTime Don\'t forget to stay hydrated!\");
	}
})',
		'Bot',
		1
	)