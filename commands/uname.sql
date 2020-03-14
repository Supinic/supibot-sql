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
		Static_Data,
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
		NULL,
		'(async function uname () {
	const data = await sb.Got.instances.GitHub(\"repos/supinic/supibot/commits\").json();
	const commits = data.sort((a, b) => new sb.Date(b.commit.author.date) - new sb.Date(a.commit.author.date));

	const {sha, commit} = commits[0];
	const message = commit.message.split(\"\\n\")[0];
	return {
		reply: `Last commit: ${sha.slice(0, 7)} - ${message}`
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function uname () {
	const data = await sb.Got.instances.GitHub(\"repos/supinic/supibot/commits\").json();
	const commits = data.sort((a, b) => new sb.Date(b.commit.author.date) - new sb.Date(a.commit.author.date));

	const {sha, commit} = commits[0];
	const message = commit.message.split(\"\\n\")[0];
	return {
		reply: `Last commit: ${sha.slice(0, 7)} - ${message}`
	};
})'