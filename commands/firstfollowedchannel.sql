INSERT INTO
	`chat_data`.`Command`
	(
		ID,
		Name,
		Aliases,
		Flags,
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
		Owner_Override,
		Archived,
		Static_Data,
		Code,
		Examples,
		Dynamic_Description
	)
VALUES
	(
		211,
		'firstfollowedchannel',
		'[\"ffc\"]',
		NULL,
		'Fetches the first channel you or someone else have ever followed on Twitch.',
		10000,
		0,
		0,
		0,
		0,
		NULL,
		0,
		1,
		0,
		1,
		1,
		0,
		0,
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
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function firstFollowedChannel (context, target) {
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

'