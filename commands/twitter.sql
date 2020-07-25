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
		67,
		'twitter',
		'[\"tweet\"]',
		'mention,pipe',
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

	const { error, data } = await sb.Twitter.fetchTweets({
		username: user,
		count: 1
	});

	if (error) {
		let errorString = null;
		if (error.error === \"Not authorized.\") {
			errorString = \"This account is either suspended or private!\";
		}
		else if (error.errors?.[0].code === 34) {
			errorString = \"This account does not exist!\";
		}

		return {
			success: false,
			reply: errorString
		};
	}

	const [tweet] = data;
	if (!tweet) {
		return {
			reply: `That account has not tweeted so far.`
		};
	}

	const delta = sb.Utils.timeDelta(new sb.Date(tweet.created_at));
	const fixedText = sb.Utils.fixHTML(tweet.text);
	return {
		reply: `${fixedText} (posted ${delta})`
	};
})',
		NULL,
		'supinic/supibot-sql'
	)