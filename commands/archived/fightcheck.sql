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
		144,
		'fightcheck',
		'[\"foodcheck\"]',
		'archived,pipe',
		'Posts all Twitch Food-Fight related emotes.',
		30000,
		NULL,
		NULL,
		'async () => ({
	reply: \"use $emotecheck food instead :)\"
})',
		NULL,
		'supinic/supibot-sql'
	)