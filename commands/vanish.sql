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
		85,
		'vanish',
		NULL,
		'Times out the user for 1 second.',
		60000,
		0,
		0,
		1,
		0,
		NULL,
		0,
		0,
		0,
		0,
		1,
		0,
		NULL,
		'(async function vanish (context) {
	if (context.channel === null || context.channel.Mode !== \"Moderator\") {
		return { reply: \"You cannot vanish here!\" };
	}
	else if (context.platform.Name !== \"twitch\") {
		return { reply: \"You cannot vanish outside of Twitch!\" };
	}
	else if (context.append.userBadges.hasModerator) {
		return { reply: \"I cannot time moderators out! monkaS\" };
	}
	else if (context.append.userBadges.hasGlobalMod) {
		return { reply: \"I cannot time global moderators out! monkaS\" };
	}
	else if (context.append.userBadges.hasBroadcaster) {
		return { reply: \"Why are you trying to vanish in your own channel? 4Head\" };
	}
	else if (context.append.userBadges.hasStaff) {
		return { reply: \"I cannot time Twitch staff out! monkaS\" };
	}
	else if (context.append.userBadges.hasAdmin) {
		return { reply: \"I cannot time Twitch administrators out! monkaS\" };
	}

	sb.Master.clients.twitch.client.privmsg(context.channel.Name, \"/timeout \" + context.user.Name + \" 1 vanished\");
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function vanish (context) {
	if (context.channel === null || context.channel.Mode !== \"Moderator\") {
		return { reply: \"You cannot vanish here!\" };
	}
	else if (context.platform.Name !== \"twitch\") {
		return { reply: \"You cannot vanish outside of Twitch!\" };
	}
	else if (context.append.userBadges.hasModerator) {
		return { reply: \"I cannot time moderators out! monkaS\" };
	}
	else if (context.append.userBadges.hasGlobalMod) {
		return { reply: \"I cannot time global moderators out! monkaS\" };
	}
	else if (context.append.userBadges.hasBroadcaster) {
		return { reply: \"Why are you trying to vanish in your own channel? 4Head\" };
	}
	else if (context.append.userBadges.hasStaff) {
		return { reply: \"I cannot time Twitch staff out! monkaS\" };
	}
	else if (context.append.userBadges.hasAdmin) {
		return { reply: \"I cannot time Twitch administrators out! monkaS\" };
	}

	sb.Master.clients.twitch.client.privmsg(context.channel.Name, \"/timeout \" + context.user.Name + \" 1 vanished\");
})'