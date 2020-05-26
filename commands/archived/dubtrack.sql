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
		147,
		'dubtrack',
		NULL,
		'archived,ping,pipe,whitelist',
		'Posts a link to supinic\'s dubtrack to use on stream, when necessary.',
		5000,
		'Only available on specific channels who have dubtrack.',
		NULL,
		'async (context) => ({ reply: \"https://www.dubtrack.fm/join/\" + context.channel.Name })',
		NULL,
		'supinic/supibot-sql'
	)