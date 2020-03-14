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
		93,
		'pyramid',
		NULL,
		'Creates a pyramid in chat. Only usable in chats where Supibot is a VIP or a Moderator.',
		60000,
		0,
		0,
		0,
		1,
		NULL,
		0,
		0,
		0,
		1,
		1,
		0,
		NULL,
		'async (extra, emote, size = 3, delay = 250) => {
	if (extra.channel.Mode === \"Write\") {
		return { reply: \"Cannot create pyramids in a non-VIP/Moderator chat!\" };
	}
	else if (!emote) {
		return { reply: \"No emote provided!\" };
	}
	else if (emote.repeat(size) > extra.channel.Message_Limit || size > 20) {
		return { reply: \"Target pyramid is either too wide or too tall!\" };
	}

	emote += \" \";
	for (let i = 1; i <= size; i++) {
		sb.Master.send(emote.repeat(i), extra.channel);
	}

	for (let i = (size - 1); i > 0; i--) {
		sb.Master.send(emote.repeat(i), extra.channel);
	}
}',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async (extra, emote, size = 3, delay = 250) => {
	if (extra.channel.Mode === \"Write\") {
		return { reply: \"Cannot create pyramids in a non-VIP/Moderator chat!\" };
	}
	else if (!emote) {
		return { reply: \"No emote provided!\" };
	}
	else if (emote.repeat(size) > extra.channel.Message_Limit || size > 20) {
		return { reply: \"Target pyramid is either too wide or too tall!\" };
	}

	emote += \" \";
	for (let i = 1; i <= size; i++) {
		sb.Master.send(emote.repeat(i), extra.channel);
	}

	for (let i = (size - 1); i > 0; i--) {
		sb.Master.send(emote.repeat(i), extra.channel);
	}
}'