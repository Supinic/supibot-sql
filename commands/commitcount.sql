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
		226,
		'commitcount',
		'[\"FarmingCommits\"]',
		'ping,pipe,skip-banphrase,system',
		'For a given GitHub user, this command gives you the amount of push events done within 24 hours. If nothing is provided, uses the current channel as a username.',
		10000,
		NULL,
		NULL,
		'(async function commitCount (context, username) {
	username = username ?? context.user.Name;

	const { body: data, statusCode} = await sb.Got.instances.GitHub(`users/${username}/events`);
	if (statusCode !== 200) {
		return {
			success: false,
			reply: `Error ${statusCode}: ${data.message}`
		};
	}

	const threshold = new sb.Date().addHours(-24);
	const eventCount = data.filter(i => new sb.Date(i.created_at) >= threshold && i.type === \"PushEvent\").length;
	const suffix = (eventCount === 1) ? \"\": \"s\";
	return {
		reply: `GitHub user ${username} has made ${eventCount} push event${suffix} in the past 24 hours.`
	};
})',
		NULL,
		'supinic/supibot-sql'
	)