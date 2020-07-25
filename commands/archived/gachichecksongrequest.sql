INSERT INTO
	`chat_data`.`Command`
	(
		ID,
		Name,
		Aliases,
		Flags,
		Description,
		Cooldown,
		Whitelist_Response,
		Static_Data,
		Code,
		Dynamic_Description,
		Source
	)
VALUES
	(
		195,
		'gachichecksongrequest',
		'[\"gcsr\", \"srgc\"]',
		'archived,mention,pipe',
		'Checks if the currently playing song on the VLC (possibly others?) API is in the gachi list. If not, basically executes the \"gc\" command.',
		10000,
		NULL,
		NULL,
		'(async function gachiCheckSongRequest (context, link) {
	if (sb.Config.get(\"SONG_REQUESTS_STATE\") !== \"vlc\") {
		return {
			reply: \"Song requests are currently not on VLC, so no data could be fetched!\"
		};
	}

	return {
		reply: (await (sb.Command.get(\"gc\").execute({}, (await sb.VideoLANConnector.currentlyPlaying()).category.meta.url))).reply
	};
})',
		NULL,
		'supinic/supibot-sql'
	)