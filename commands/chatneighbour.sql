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
		'ping,pipe',
		NULL,
		10000,
		NULL,
		NULL,
		'(async function (context) {
	if (!context.channel) {
		return {
			success: false,
			reply: \"It\'s just us two here in private messages...\"
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

	const selfIndex = list.indexOf(context.user.Name);
	const neighbours = [list[selfIndex - 1], list[selfIndex + 1]].filter(Boolean);
	if (neighbours.length === 0) {
		return {
			reply: `You have no chat neighbours. (?)`
		};
	}

	return {
		reply: `Your chat neighbour(s): ${neighbours.join(\", \")}`
	};
})',
		NULL,
		'supinic/supibot-sql'
	)