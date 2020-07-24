INSERT INTO
	`chat_data`.`Cron`
	(
		ID,
		Name,
		Expression,
		Description,
		Defer,
		Code,
		Type,
		Active
	)
VALUES
	(
		19,
		'ggg-tracker',
		'0 * * * * *',
		'Checks gggtracker.com periodically for new posts by GGG staff members.',
		NULL,
		'(async function trackGGG () {
	//if (!this.data.enabled) {
	//	return;
	//}

	const { activity } = await sb.Got(\"https://gggtracker.com/activity.json\").json();
	activity.sort((a, b) => new sb.Date(b.data.time) - new sb.Date(a.data.time));

	const [{ type, data }] = activity;
	if (!this.data.latestID) {
		this.data.latestID = data.id;
	}
	else if (this.data.latestID !== data.id) {
		const users = await sb.Query.getRecordset(rs => rs
			.select(\"User_Alias.Name AS Username\")
			.from(\"chat_data\", \"Event_Subscription\")
			.join(\"chat_data\", \"User_Alias\")
			.where(\"Active = %b\", true)
			.where(\"Type = %s\", \"GGG tracker\")
			.flat(\"Username\")
		)

		this.data.latestID = data.id;

		let message = \"\";
		if (type === \"reddit_post\") {
			const link = \"https://old.reddit.com/\" + data.permalink.split(\"/\").slice(0, -2).join(\"/\");
			message = `New Reddit post by ${data.author}: ${data.title} ${link}`
		}
		else {
			return;
		}

		const channelData = sb.Channel.get(\"supinic\", \"twitch\");
		await channelData.send(users.join(\", \") + \" PogChamp 👉 \" + message);
	}
})',
		'Bot',
		1
	)