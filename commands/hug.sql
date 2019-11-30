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
		70,
		'hug',
		NULL,
		'Hugs target user :)',
		5000,
		0,
		0,
		0,
		0,
		NULL,
		0,
		1,
		0,
		0,
		1,
		0,
		'async (extra, user) => {
	if (!user) {
		return {  reply: \"You didn\'t want to hug anyone, so I\'ll hug you instead 🤗\" };
	}
	else if (user.toLowerCase() === sb.Config.get(\"TWITCH_SELF\")) {
		return { reply: \"Thanks for the hug supiniOkay <3\" };
	}
	else {
		return { reply: extra.user.Name + \" hugs \" + user + \" 🤗\" };
	}
}',
		'No arguments.',
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async (extra, user) => {
	if (!user) {
		return {  reply: \"You didn\'t want to hug anyone, so I\'ll hug you instead 🤗\" };
	}
	else if (user.toLowerCase() === sb.Config.get(\"TWITCH_SELF\")) {
		return { reply: \"Thanks for the hug supiniOkay <3\" };
	}
	else {
		return { reply: extra.user.Name + \" hugs \" + user + \" 🤗\" };
	}
}'