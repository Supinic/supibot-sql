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
		108,
		'botlevels',
		NULL,
		'skip-banphrase',
		'Posts the summary of community bots in #supinic channel on Twitch.',
		10000,
		NULL,
		NULL,
		'(async function botLevels () {
	return {
		reply: \"Bots: https://supinic.com/bot/channel-bots // Levels: https://supinic.com/bot/channel-bots/levels // Badges: https://supinic.com/bot/channel-bots/badges\"
	};
})',
		NULL,
		'supinic/supibot-sql'
	)