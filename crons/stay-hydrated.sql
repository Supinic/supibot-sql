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
		15,
		'stay-hydrated',
		'0 20 * * * *',
		'Stay hydrated!',
		NULL,
		'(async function announceStayHydrated () {
	const channelData = sb.Channel.get(\"supinic\", \"twitch\");
	if (channelData.sessionData.live) {
		await channelData.send(\"OMGScoots TeaTime Don\'t forget to stay hydrated!\");
	}
})',
		'Bot',
		1
	)