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
		152,
		'uname',
		'[\"version\"]',
		'developer,mention,pipe',
		'Posts the current supibot version, along with the latest \"patch notes\"',
		10000,
		NULL,
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
		'supinic/supibot-sql'
	)