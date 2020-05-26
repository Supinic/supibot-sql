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
		97,
		'gachi',
		'[\"gachilist\", \"gl\"]',
		'ping,pipe',
		'Posts the link of gachimuchi list on supinic.com',
		10000,
		NULL,
		NULL,
		'async () => ({ reply: \"https://supinic.com/gachi/list\" })',
		NULL,
		'supinic/supibot-sql'
	)