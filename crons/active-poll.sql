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
		6,
		'active-poll',
		'0 15,45 * * * *',
		'If a poll is running, announce it in chat every couple of minutes.',
		'async () => {
	const now = new sb.Date();
	const poll = await sb.Query.getRecordset(rs => rs
		.select(\"ID\", \"Text\")
		.from(\"chat_data\", \"Poll\")
		.where(\"Status = %s\", \"Active\")
		.where(\"Start < NOW() AND End > NOW()\")
		.single()
	);

	if (poll) {
		const channelData = sb.Channel.get(\"supinic\", \"twitch\");
		await channelData.send(`Poll ID ${poll.ID} is currently running! Vote with \"$vote yes\" or \"$vote no\"! MEGADANK 👉 ${poll.Text}`);
	}
}',
		'Bot',
		1
	)