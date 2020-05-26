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
		18,
		'isafk',
		'[\"afkcheck\", \"checkafk\"]',
		'archived,ping,pipe',
		'Checks if given user is AFK',
		5000,
		NULL,
		NULL,
		'async () => ({
	reply: \"This command is deprecated, please use $check afk <user>\"	
})',
		NULL,
		'supinic/supibot-sql'
	)