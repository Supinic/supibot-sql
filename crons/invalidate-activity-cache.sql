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
		14,
		'invalidate-activity-cache',
		'0 0 0 * * *',
		'Periodically (every midnight) clears channel activity cache on the website.',
		'(async function invalidateWebsiteActivityCache () {
	sb.App.cache.channelActivity = {};
})',
		'Website',
		1
	)