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
		147,
		'dubtrack',
		NULL,
		NULL,
		'Posts a link to supinic\'s dubtrack to use on stream, when necessary.',
		5000,
		0,
		0,
		0,
		1,
		'Only available on specific channels who have dubtrack.',
		0,
		0,
		0,
		1,
		1,
		0,
		1,
		NULL,
		'async (context) => ({ reply: \"https://www.dubtrack.fm/join/\" + context.channel.Name })',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async (context) => ({ reply: \"https://www.dubtrack.fm/join/\" + context.channel.Name })'