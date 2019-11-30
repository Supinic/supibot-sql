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
		Code,
		Examples,
		Dynamic_Description
	)
VALUES
	(
		108,
		'botlevels',
		NULL,
		'Posts the summary of community bots in #supinic channel on Twitch.',
		10000,
		0,
		0,
		1,
		1,
		NULL,
		0,
		0,
		0,
		0,
		0,
		0,
		'async () => ({ reply: \"Bots: https://supinic.com/bot/channel-bots || Levels: https://supinic.com/bot/channel-bots/levels\" })',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async () => ({ reply: \"Bots: https://supinic.com/bot/channel-bots || Levels: https://supinic.com/bot/channel-bots/levels\" })'