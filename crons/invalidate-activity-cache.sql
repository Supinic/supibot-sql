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
		14,
		'invalidate-activity-cache',
		'0 0 0 * * *',
		'Periodically (every midnight) clears channel activity cache on the website.',
		NULL,
		'(async function invalidateWebsiteActivityCache () {
	sb.App.cache.channelActivity = {};
})',
		'Website',
		1
	)