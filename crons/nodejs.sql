INSERT INTO
	`chat_data`.`Cron`
	(
		ID,
		Name,
		Expression,
		Description,
		Code,
		Type,
		Active
	)
VALUES
	(
		4,
		'nodejs',
		'0 0 */1 * * *',
		'Checks new releases of nodejs, and if one is detected, then posts it in chat.',
		'(async function cron_nodejs () {
	const rawData = await sb.Got.instances.GitHub({
		url: \"repos/nodejs/node/releases\",
	}).json();

	const latest = rawData.sort((a, b) => new sb.Date(b.created_at) - new sb.Date(a.created_at)).shift();
	if (latest.tag_name !== sb.Config.get(\"LATEST_NODE_JS_VERSION\")) {
		sb.Config.set(\"LATEST_NODE_JS_VERSION\", latest.tag_name);
		
		const pingedUsers = (await sb.Query.getRecordset(rs => rs
			.select(\"User_Alias.Name AS Username\")
			.from(\"chat_data\", \"Event_Subscription\")
			.join(\"chat_data\", \"User_Alias\")
			.where(\"Type = %s\", \"Node.js updates\")
			.where(\"Active = %b\", true)
			.flat(\"Username\")
		)).map(i => `@${i}`).join(\" \");
		
		sb.Master.send(`${pingedUsers} New Node.js version detected! PagChomp 👉 ${latest.tag_name} Changelog: ${latest.html_url}`, 38);
	}
})',
		'Bot',
		1
	)