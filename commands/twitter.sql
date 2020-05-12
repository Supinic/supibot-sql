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
		'(async function twitter (context, user) {
	if (!user) {
		return {
			success: false,
			reply: \"No user provided!\" 
		};
	}


	try {
		const [data] = await sb.Twitter.fetchTweets({
			username: user,
			count: 1
		});

		const delta = sb.Utils.timeDelta(new sb.Date(data.created_at));
		const fixedText = sb.Utils.fixHTML(data.text);

		return {
			reply: `${fixedText} (posted ${delta})`
		};
	}
	catch (e) {
		console.warn(\"Twitter error\", e);
		return {
			success: false,
			reply: e.errors[0].message
		};
	}
})',
		NULL
	)