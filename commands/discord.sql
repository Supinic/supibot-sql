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
		165,
		'discord',
		NULL,
		'ping,pipe',
		'Posts the link to the current channel\'s Discord(?)',
		15000,
		NULL,
		NULL,
		'(async function discord (context) {
	return { reply: \"Join the Hackerman club today! Now with subscriber emotes supiniOkay https://discord.gg/wHWjRzp\" };
})',
		NULL
	)