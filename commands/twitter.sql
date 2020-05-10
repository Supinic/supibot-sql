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
		67,
		'twitter',
		NULL,
		'ping,pipe',
		'Fetches the last tweet from a given user. No retweets or replies, just plain standalone tweets.',
		10000,
		NULL,
		NULL,
		'async (extra, user) => {
	if (!user) {
		return { reply: \"No user provided!\" };
	}
	
	const data = await sb.Twitter.lastUserTweets(user);
	if (data.success) {
		return {
			reply: data.text + \" (\" + sb.Utils.timeDelta(data.date) + \")\"
		};
	}
	else {
		return { reply: data.text };
	}

}',
		NULL,
		NULL
	)