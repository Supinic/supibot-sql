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
		9,
		'detect-offline-stream',
		'0 * * * * *',
		'Checks if the channel \"supinic\" is offline, to unset stream variables like \"sr\", \"tts\" and others.',
		NULL,
		'(async function detectOfflineStream () {
	const sr = sb.Config.get(\"SONG_REQUESTS_STATE\");
	if (sr === \"off\") {
		return;
	}

	const { reply } = await sb.Command.get(\"si\").execute({}, \"supinic\");
	if (reply.includes(\"offline\")) {
		sb.Config.set(\"SONG_REQUESTS_STATE\", \"off\");
		sb.Config.set(\"TTS_ENABLED\", false);
		
		const channelData = sb.Channel.get(\"supinic\", \"twitch\");
		await channelData.send(\"Channel has been detected as offline! Disabling song requests and TTS.\");
	}
})',
		'Bot',
		0
	)