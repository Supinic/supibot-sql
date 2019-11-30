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
		111,
		'levelchange',
		'[\"lc\"]',
		'Search for the last level change (default, staff, admin, ...) of a given Twitch user.',
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
		'async (extra, user, index) => {
	user = user || extra.user.Name;
	index = Number(index) || 0;

	const url = `https://twitch-tools.rootonline.de/user_type_changelogs_search.php?format=json&q=${user}`;
	const topData = JSON.parse(await sb.Utils.request(url));
	const data = topData[index];
	
	if (!data) {
		return {
			reply: (index === 0)
				? \"No level change found for that user.\"
				: \"Specified index is out of bounds.\"
		};
	}
	
	const addendum = (index === 0 && topData.length !== 1)
		? (topData.length - 1) + \" more change(s) found.\"
		: \"\";
	return {
		reply: `Level change (index ${index}) for user ${data.username}: ${data.type_old} -> ${data.type_new}. This was ${sb.Utils.timeDelta(new sb.Date(data.found_at))}. ${addendum}`
	};
}',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async (extra, user, index) => {
	user = user || extra.user.Name;
	index = Number(index) || 0;

	const url = `https://twitch-tools.rootonline.de/user_type_changelogs_search.php?format=json&q=${user}`;
	const topData = JSON.parse(await sb.Utils.request(url));
	const data = topData[index];
	
	if (!data) {
		return {
			reply: (index === 0)
				? \"No level change found for that user.\"
				: \"Specified index is out of bounds.\"
		};
	}
	
	const addendum = (index === 0 && topData.length !== 1)
		? (topData.length - 1) + \" more change(s) found.\"
		: \"\";
	return {
		reply: `Level change (index ${index}) for user ${data.username}: ${data.type_old} -> ${data.type_new}. This was ${sb.Utils.timeDelta(new sb.Date(data.found_at))}. ${addendum}`
	};
}'