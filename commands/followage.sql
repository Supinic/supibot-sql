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
		116,
		'followage',
		'[\"fa\"]',
		'Fetches the followage <user> <channel>. If no channel provided, checks the current one. If no user provided either, checks yourself.',
		10000,
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
		NULL,
		'(async function followAge (context, user, channel) {
	if (!channel) {
		if (!context.channel) {
			return {
				reply: \"There is no channel to use here!\"
			};
		}

		if (context.platform.Name === \"twitch\") {
			channel = context.channel.Name;
		}
		// If used in a mirrored channel outside of Twitch, use the mirror target channel instead.
		else if (context.channel.Mirror) {
			const mirrorChannel = sb.Channel.get(context.channel.Mirror);
			if (mirrorChannel.Platform.Name === \"twitch\") {
				channel = mirrorChannel.Name;
			}
		}

		if (!channel) {
			return {
				reply: \"Could not find any associated Twitch channels! Please specify one.\"
			};
		}
	}

	if (!user) {
		user = context.user.Name;
	}

	if (user === channel.toLowerCase()) {
		if (user === context.user.Name) {
			return { reply: \"Good luck following yourself! PepeLaugh\" };
		}
		else {
			return { reply: \"You can\'t follow yourself!\" };
		}
	}

	const [userID, channelID] = await Promise.all([
		sb.Utils.getTwitchID(user),
		sb.Utils.getTwitchID(channel)
	]);

	if (!userID || !channelID) {
		return {
			reply: \"One or both users were not found!\"
		};
	}

	const data = await sb.Got.instances.Twitch.Kraken({
		url: `users/${userID}/follows/channels/${channelID}`,
		throwHttpErrors: false
	});

	if (data.error && data.status === 404) {
		return {
			reply: `${user} is not following ${channel}.`
		};
	}
	else {
		const delta = sb.Utils.timeDelta(new sb.Date(data.created_at), true);
		return {
			reply: `${user} has been following ${channel} for ${delta}.`
		};
	}
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function followAge (context, user, channel) {
	if (!channel) {
		if (!context.channel) {
			return {
				reply: \"There is no channel to use here!\"
			};
		}

		if (context.platform.Name === \"twitch\") {
			channel = context.channel.Name;
		}
		// If used in a mirrored channel outside of Twitch, use the mirror target channel instead.
		else if (context.channel.Mirror) {
			const mirrorChannel = sb.Channel.get(context.channel.Mirror);
			if (mirrorChannel.Platform.Name === \"twitch\") {
				channel = mirrorChannel.Name;
			}
		}

		if (!channel) {
			return {
				reply: \"Could not find any associated Twitch channels! Please specify one.\"
			};
		}
	}

	if (!user) {
		user = context.user.Name;
	}

	if (user === channel.toLowerCase()) {
		if (user === context.user.Name) {
			return { reply: \"Good luck following yourself! PepeLaugh\" };
		}
		else {
			return { reply: \"You can\'t follow yourself!\" };
		}
	}

	const [userID, channelID] = await Promise.all([
		sb.Utils.getTwitchID(user),
		sb.Utils.getTwitchID(channel)
	]);

	if (!userID || !channelID) {
		return {
			reply: \"One or both users were not found!\"
		};
	}

	const data = await sb.Got.instances.Twitch.Kraken({
		url: `users/${userID}/follows/channels/${channelID}`,
		throwHttpErrors: false
	});

	if (data.error && data.status === 404) {
		return {
			reply: `${user} is not following ${channel}.`
		};
	}
	else {
		const delta = sb.Utils.timeDelta(new sb.Date(data.created_at), true);
		return {
			reply: `${user} has been following ${channel} for ${delta}.`
		};
	}
})'