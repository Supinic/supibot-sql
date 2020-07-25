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
		93,
		'pyramid',
		NULL,
		'mention,pipe,whitelist',
		'Creates a pyramid in chat. Only usable in chats where Supibot is a VIP or a Moderator.',
		60000,
		NULL,
		NULL,
		'(async function pyramid (context, emote, size = 3) {
	if (context.channel.Mode !== \"Moderator\" && context.channel.Mode !== \"VIP\") {
		return { reply: \"Cannot create pyramids in a non-VIP/Moderator chat!\" };
	}
	else if (!emote) {
		return { reply: \"No emote provided!\" };
	}
	else if (emote.repeat(size) > context.channel.Message_Limit || size > 20) {
		return { reply: \"Target pyramid is either too wide or too tall!\" };
	}

	emote += \" \";
	
	for (let i = 1; i <= size; i++) {
		context.channel.send(emote.repeat(i));
	}

	for (let i = (size - 1); i > 0; i--) {
		context.channel.send(emote.repeat(i));
	}
	
	return null;
})',
		NULL,
		'supinic/supibot-sql'
	)