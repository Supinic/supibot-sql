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
		'(async function cron_stayHydrated () {
	const channelData = sb.Channel.get(38);
	if (channelData.sessionData.live) {
		sb.Master.send(\"OMGScoots TeaTime Don\'t forget to stay hydrated!\", channelData);
	}
})',
		'Bot',
		1
	)