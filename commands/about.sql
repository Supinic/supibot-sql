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
		103,
		'about',
		NULL,
		'ping,pipe',
		'Posts a summary of what supibot does, and what it is.',
		60000,
		NULL,
		NULL,
		'(async function about () {
	return {	
		reply: \"Supibot is a smol variety and utility bot supiniL running on a smol Raspberry Pi 3B supiniL not primarily designed for moderation supiniHack running on Node.js since Feb 2018.\"
	};
})',
		NULL,
		'supinic/supibot-sql'
	)