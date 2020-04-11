INSERT INTO
	`chat_data`.`Command`
	(
		ID,
		Name,
		Aliases,
		Flags,
		Description,
		Cooldown,
		Rollbackable,
		System,
		Skip_Banphrases,
		Whitelisted,
		Whitelist_Response,
		Read_Only,
		Opt_Outable,
		Blockable,
		Ping,
		Pipeable,
		Owner_Override,
		Archived,
		Static_Data,
		Code,
		Examples,
		Dynamic_Description
	)
VALUES
	(
		195,
		'gachichecksongrequest',
		'[\"gcsr\", \"srgc\"]',
		NULL,
		'Checks if the currently playing song on the VLC (possibly others?) API is in the gachi list. If not, basically executes the \"gc\" command.',
		10000,
		0,
		0,
		0,
		0,
		NULL,
		0,
		0,
		0,
		1,
		1,
		0,
		1,
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
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function gachiCheckSongRequest (context, link) {
	if (sb.Config.get(\"SONG_REQUESTS_STATE\") !== \"vlc\") {
		return {
			reply: \"Song requests are currently not on VLC, so no data could be fetched!\"
		};
	}

	return {
		reply: (await (sb.Command.get(\"gc\").execute({}, (await sb.VideoLANConnector.currentlyPlaying()).category.meta.url))).reply
	};
})'