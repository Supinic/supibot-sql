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
		Dynamic_Description
	)
VALUES
	(
		88,
		'pipozdola',
		NULL,
		'ping,pipe,skip-banphrase,whitelist',
		'PIP OMEGALUL ZD OMEGALUL LA',
		10000,
		NULL,
		NULL,
		'async () => ({
	reply: \"https://pastebin.com/PzSHPzH0\"
})',
		NULL
	)