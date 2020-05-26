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
		211,
		'firstfollowedchannel',
		'[\"ffc\"]',
		'opt-out,ping,pipe',
		'Fetches the first channel you or someone else have ever followed on Twitch.',
		10000,
		NULL,
		NULL,
		'(async function firstFollowedChannel (context, target) {
	const ID = await sb.Utils.getTwitchID(target || context.user.Name);
	if (!ID) {
		return {
			success: false,
			reply: \"Could not match user to a Twitch user ID!\"
		};
	}

	const { follows } = await sb.Got.instances.Twitch.Kraken({
		url: `users/${ID}/follows/channels`,
		searchParams: new sb.URLParams()
			.set(\"limit\", \"10\") // If the limit is 1, and the followed channel is banned, then no response will be used...
			.set(\"direction\", \"asc\")
			.set(\"sortby\", \"created_at\")
			.toString()
	}).json();

	if (follows.length === 0) {
		return {
			reply: \"That user does not follow anyone.\"
		};
	}
	else {
		const follow = follows[0];
		const delta = sb.Utils.timeDelta(new sb.Date(follow.created_at));
		const who = (!target || context.user.Name === target.toLowerCase()) 
			? \"Your\"
			: \"Their\";

		return {
			reply: `${who} oldest still followed channel is ${follow.channel.display_name}, since ${delta}.`
		};
	}
})

',
		NULL,
		'supinic/supibot-sql'
	)