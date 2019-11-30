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
		67,
		'twitter',
		NULL,
		'Fetches the last tweet from a given user. No retweets or replies, just plain standalone tweets.',
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

ON DUPLICATE KEY UPDATE
	Code = 'async (extra, user) => {
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

}'