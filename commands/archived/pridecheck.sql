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
		112,
		'pridecheck',
		NULL,
		'archived,ping,pipe',
		'KappaPride',
		10000,
		NULL,
		NULL,
		'async () => ({ reply: \"use $emotecheck pride instead :)\" })',
		NULL
	)