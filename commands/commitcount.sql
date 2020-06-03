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
		'For a given repository, gives you the amount of commits done within this day (UTC). If nothing is provided, uses supibot\'s repo.',
		10000,
		NULL,
		NULL,
		'(async function commitCount (context, owner, repo) {
	if (owner && !repo) {
		[owner, repo] = owner.split(\"/\");
	}
	else if (!owner && !repo) {
		owner = \"supinic\";
		repo = \"supibot\";
	}

	if (!owner || !repo) {
		return {
			success: false,
			reply: \"Invalid owner or repository!\"
		};
	}	

	const { year, month, day } = new sb.Date();
	const { statusCode, body: data } = await sb.Got.instances.GitHub({
		url: `repos/${owner}/${repo}/commits?page=1`,
		throwHttpErrors: false
	});

	if (statusCode !== 200) {
		return {
			success: false,
			reply: \"Target owner/repo does not exist!\"
		};
	}

	const today = data.filter(i => {
		const date = new sb.Date(i.commit.committer.date);
		return (date.year === year && date.month === month && date.day === day);
	});

	return {
		reply: `There have been ${today.length} commits to repo ${owner}/${repo} today. FarmingCommits`
	};
})',
		NULL,
		'supinic/supibot-sql'
	)