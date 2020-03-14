INSERT INTO
	`chat_data`.`Command`
	(
		ID,
		Name,
		Aliases,
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
		Archived,
		Static_Data,
		Code,
		Examples,
		Dynamic_Description
	)
VALUES
	(
		167,
		'wrongsong',
		'[\"ws\"]',
		'If you have requested at least one song, this command is going to skip the first one. Use when you accidentally requested something you didn\'t mean to.',
		5000,
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
		NULL,
		'(async function wrongSong (context) {
	const result = await sb.VideoLANConnector.wrongSong(context.user.ID);
	
	if (!result.success) {
		return { reply: \"Your song could not be skipped, reason: \" + result.reason };
	}
	else {
		return { reply: \"Your song request \" + result.song.name + \" has been deleted succesfully.\" };
	}
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function wrongSong (context) {
	const result = await sb.VideoLANConnector.wrongSong(context.user.ID);
	
	if (!result.success) {
		return { reply: \"Your song could not be skipped, reason: \" + result.reason };
	}
	else {
		return { reply: \"Your song request \" + result.song.name + \" has been deleted succesfully.\" };
	}
})'