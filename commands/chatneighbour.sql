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
		231,
		'chatneighbour',
		'[\"cn\"]',
		'pipe',
		NULL,
		10000,
		NULL,
		NULL,
		'(async function (context, targetUser) {
	if (!context.channel) {
		return {
			reply: \"It\'s just the two us here, in private messages...\"
		};
	}
	else if (context.platform.Name !== \"twitch\") {
		return {
			success: false,
			reply: \"This command can only be used on Twitch!\"
		};
	}

	const { chatters } = await sb.Got(`http://tmi.twitch.tv/group/user/${context.channel.Name}/chatters`).json();
	const list = Object.values(chatters).flat().sort();
	if (list.length < 2) {
		return {
			reply: \"There don\'t seem to be enough people here.\"
		};
	}

	const userData = (targetUser)
		? await sb.User.get(targetUser)
		: context.user;

	if (!userData) {
		return {
			success: false,
			reply: \"That user does not exist!\"
		};
	}

	const index = list.indexOf(userData.Name);
	if (index === -1) {
		return {
			success: false,
			reply: \"That user is not currently present in chat!\"
		};
	}

	const neighbours = [list[index - 1], list[index], list[index + 1]]
		.filter(Boolean)
		.map(i => i[0] + \"\\u{E0000}\" + i.slice(1));

	if (neighbours.length < 2) {
		return {
			reply: `No chat neighbours have been detected... This shouldn\'t happen?`
		};
	}

	return {
		meta: {
			skipWhitespaceCheck: true
		},

		reply: `Chat neighbour(s): ${neighbours.join(\" 🤝 \")}`
	};
})',
		NULL,
		'supinic/supibot-sql'
	)