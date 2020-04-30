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
		9,
		'detect-offline-stream',
		'0 * * * * *',
		'Checks if the channel \"supinic\" is offline, to unset stream variables like \"sr\", \"tts\" and others.',
		'(async function cron_detectOfflineStream () {
	return;

	const sr = sb.Config.get(\"SONG_REQUESTS_STATE\");
	if (sr === \"off\") {
		return;
	}

	const { reply } = await sb.Command.get(\"si\").execute({}, \"supinic\");
	if (reply.includes(\"offline\")) {
		sb.Config.set(\"SONG_REQUESTS_STATE\", \"off\");
		sb.Config.set(\"TTS_ENABLED\", false);
		
		sb.Master.send(\"Channel has been detected as offline! Disabling song requests and TTS.\", 38);
	}
})',
		'Bot',
		1
	)