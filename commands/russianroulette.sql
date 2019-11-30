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
		139,
		'russianroulette',
		'[\"rr\"]',
		'Play the roulette. If you win, nothing happens; if you lose, you get timed out. Only works in channels where Supibot is Moderator, on Twitch only, obviously.',
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
		'(async function russianRoulette (context, timeoutLength) {
	if (context.channel === null || context.channel.Mode !== \"Moderator\") {
		return { reply: \"You cannot play the roulette in here!\" };
	}
	else if (context.channel.Platform !== \"Twitch\") {
		return { reply: \"You cannot play the roulette outside of Twitch!\" };
	}
	else if (context.append.userBadges.hasModerator) {
		return { reply: \"Moderators can\'t be timed out, cheaters!\" };
	}
	else if (context.append.userBadges.hasGlobalMod) {
		return { reply: \"Global moderators can\'t be timed out, cheaters!\" };
	}
	else if (context.append.userBadges.hasBroadcaster) {
		return { reply: \"Broadcasters can\'t be timed out, cheaters!\" };
	}
	else if (context.append.userBadges.hasStaff) {
		return { reply: \"Staff can\'t be timed out, cheaters!\" };
	}
	else if (context.append.userBadges.hasAdmin) {
		return { reply: \"Admins can\'t be timed out, cheaters! monkaS\" };
	}

	timeoutLength = (timeoutLength) ? Number(timeoutLength) : 1;
	if (timeoutLength < 1 || !Number.isFinite(timeoutLength) || Math.round(timeoutLength) !== timeoutLength) {
		return { reply: \"Invalid timeout length provided!\" };
	}
	else if (timeoutLength > 600) {
		return { reply: \"Maximum timeout length exceeded!\" };
	}

	const result = sb.Utils.random(1, 6);
	if (result === 1) {
		sb.Master.clients.twitch.client.privmsg(
			context.channel.Name, 
			`/timeout ${context.user.Name} ${timeoutLength} Lost the roulette`
		);

		return { reply: \"Bang! It\'s over.\" };
	}
	else {
		return { reply: \"Click! You are safe.\" };
	}
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function russianRoulette (context, timeoutLength) {
	if (context.channel === null || context.channel.Mode !== \"Moderator\") {
		return { reply: \"You cannot play the roulette in here!\" };
	}
	else if (context.channel.Platform !== \"Twitch\") {
		return { reply: \"You cannot play the roulette outside of Twitch!\" };
	}
	else if (context.append.userBadges.hasModerator) {
		return { reply: \"Moderators can\'t be timed out, cheaters!\" };
	}
	else if (context.append.userBadges.hasGlobalMod) {
		return { reply: \"Global moderators can\'t be timed out, cheaters!\" };
	}
	else if (context.append.userBadges.hasBroadcaster) {
		return { reply: \"Broadcasters can\'t be timed out, cheaters!\" };
	}
	else if (context.append.userBadges.hasStaff) {
		return { reply: \"Staff can\'t be timed out, cheaters!\" };
	}
	else if (context.append.userBadges.hasAdmin) {
		return { reply: \"Admins can\'t be timed out, cheaters! monkaS\" };
	}

	timeoutLength = (timeoutLength) ? Number(timeoutLength) : 1;
	if (timeoutLength < 1 || !Number.isFinite(timeoutLength) || Math.round(timeoutLength) !== timeoutLength) {
		return { reply: \"Invalid timeout length provided!\" };
	}
	else if (timeoutLength > 600) {
		return { reply: \"Maximum timeout length exceeded!\" };
	}

	const result = sb.Utils.random(1, 6);
	if (result === 1) {
		sb.Master.clients.twitch.client.privmsg(
			context.channel.Name, 
			`/timeout ${context.user.Name} ${timeoutLength} Lost the roulette`
		);

		return { reply: \"Bang! It\'s over.\" };
	}
	else {
		return { reply: \"Click! You are safe.\" };
	}
})'