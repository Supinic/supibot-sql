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
		132,
		'inspireme',
		NULL,
		'Inspires you. Randomly.',
		15000,
		0,
		0,
		0,
		0,
		NULL,
		0,
		0,
		0,
		1,
		1,
		0,
		'async (extra) => {
	if (!extra.channel.Links_Allowed) {
		return { reply: \"Command not available in channels with links disabled!\" };
	}

	return { reply: await sb.Utils.request(\"https://inspirobot.me/api?generate=true\") };
}',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async (extra) => {
	if (!extra.channel.Links_Allowed) {
		return { reply: \"Command not available in channels with links disabled!\" };
	}

	return { reply: await sb.Utils.request(\"https://inspirobot.me/api?generate=true\") };
}'