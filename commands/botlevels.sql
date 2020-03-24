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
		NULL,
		'(async function botLevels () {
	return {
		reply: \"Bots: https://supinic.com/bot/channel-bots // Levels: https://supinic.com/bot/channel-bots/levels // Badges: https://supinic.com/bot/channel-bots/badges\"
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function botLevels () {
	return {
		reply: \"Bots: https://supinic.com/bot/channel-bots // Levels: https://supinic.com/bot/channel-bots/levels // Badges: https://supinic.com/bot/channel-bots/badges\"
	};
})'