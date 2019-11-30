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
		152,
		'uname',
		'[\"version\"]',
		'Posts the current supibot version, along with the latest \"patch notes\"',
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
		'(async function uname () {
	const latest = await sb.Query.getRecordset(rs => rs
		.select(\"Version\", \"Subversion\", \"Build\", \"Summary\", \"Timestamp\")
		.from(\"data\", \"Patch_Notes\")
		.orderBy(\"ID DESC\")
		.limit(1)
		.single()
	);

	const githubData = JSON.parse(await sb.Utils.request({
		url: \"https://api.github.com/repos/supinic/supibot/commits\",
		headers: {
			\"User-Agent\": \"supibot @twitch.tv/supibot\"
		}
	})).sort((a, b) => new sb.Date(b.commit.author.date) - new sb.Date(a.commit.author.date));

	const {sha, commit} = githubData[0];
	const message = commit.message.split(\"\\n\")[0];

	return {
		reply: `Running version ${latest.Version}.${latest.Subversion}.${latest.Build}+${sha.slice(0, 7)} - ${message}`
	};	
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function uname () {
	const latest = await sb.Query.getRecordset(rs => rs
		.select(\"Version\", \"Subversion\", \"Build\", \"Summary\", \"Timestamp\")
		.from(\"data\", \"Patch_Notes\")
		.orderBy(\"ID DESC\")
		.limit(1)
		.single()
	);

	const githubData = JSON.parse(await sb.Utils.request({
		url: \"https://api.github.com/repos/supinic/supibot/commits\",
		headers: {
			\"User-Agent\": \"supibot @twitch.tv/supibot\"
		}
	})).sort((a, b) => new sb.Date(b.commit.author.date) - new sb.Date(a.commit.author.date));

	const {sha, commit} = githubData[0];
	const message = commit.message.split(\"\\n\")[0];

	return {
		reply: `Running version ${latest.Version}.${latest.Subversion}.${latest.Build}+${sha.slice(0, 7)} - ${message}`
	};	
})'