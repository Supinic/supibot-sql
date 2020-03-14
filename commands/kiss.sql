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
		Static_Data,
		Code,
		Examples,
		Dynamic_Description
	)
VALUES
	(
		121,
		'kiss',
		NULL,
		'Kisses target user.',
		10000,
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
		NULL,
		'async (extra, user, emote) => {
	if (!user || user.toLowerCase() === extra.user.Name) {
		return { reply: \"You can\'t really kiss yourself 😕\" };
	}
	else if (user === sb.Config.get(\"SELF\")) {
		return { reply: \"😊\" };
	}
	else {
		const target = (emote)
			? emote + \" 💋\"
			: sb.Utils.randArray(sb.Config.get(\"KISS_EMOJIS\"));
	
		return { reply: extra.user.Name + \" kisses \" + user + \" \" + target };
	}
}',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async (extra, user, emote) => {
	if (!user || user.toLowerCase() === extra.user.Name) {
		return { reply: \"You can\'t really kiss yourself 😕\" };
	}
	else if (user === sb.Config.get(\"SELF\")) {
		return { reply: \"😊\" };
	}
	else {
		const target = (emote)
			? emote + \" 💋\"
			: sb.Utils.randArray(sb.Config.get(\"KISS_EMOJIS\"));
	
		return { reply: extra.user.Name + \" kisses \" + user + \" \" + target };
	}
}'