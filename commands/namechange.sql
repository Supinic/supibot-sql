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
		25,
		'namechange',
		'[\"nc\"]',
		'Search for the last name change of a given Twitch user.',
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
		'(async function (context, user, index) {
	if (!user) {
		user = context.user.Name;
	}

	index = Number(index);
	if (!Number.isFinite(index) || index < 0 || !index) {
		index = 0;
	}

	const topData = await sb.Got.instances.CommanderRoot({
		url: \"username_changelogs_search.php\",
		searchParams: new sb.URLParams()
			.set(\"format\", \"json\")
			.set(\"q\", user)
			.toString()
	}).json();

	const data = topData[index];
	if (!data) {
		const specificReply = (context.user.Name === user)
			? \"No namechange found for you.\"
			: \"No namechange found for that user.\";

		return {
			reply: (index === 0)
				? specificReply
				: \"Specified index is out of bounds.\"
		};
	}

	const addendum = (index === 0 && topData.length !== 1)
		? (topData.length - 1) + \" more change(s) found.\"
		: \"\";
	
	return {
		reply:`Last name change for user ${data.userid}: ${data.username_old} -> ${data.username_new}. This was ${sb.Utils.timeDelta(new sb.Date(data.found_at))}. ${addendum}`
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function (context, user, index) {
	if (!user) {
		user = context.user.Name;
	}

	index = Number(index);
	if (!Number.isFinite(index) || index < 0 || !index) {
		index = 0;
	}

	const topData = await sb.Got.instances.CommanderRoot({
		url: \"username_changelogs_search.php\",
		searchParams: new sb.URLParams()
			.set(\"format\", \"json\")
			.set(\"q\", user)
			.toString()
	}).json();

	const data = topData[index];
	if (!data) {
		const specificReply = (context.user.Name === user)
			? \"No namechange found for you.\"
			: \"No namechange found for that user.\";

		return {
			reply: (index === 0)
				? specificReply
				: \"Specified index is out of bounds.\"
		};
	}

	const addendum = (index === 0 && topData.length !== 1)
		? (topData.length - 1) + \" more change(s) found.\"
		: \"\";
	
	return {
		reply:`Last name change for user ${data.userid}: ${data.username_old} -> ${data.username_new}. This was ${sb.Utils.timeDelta(new sb.Date(data.found_at))}. ${addendum}`
	};
})'