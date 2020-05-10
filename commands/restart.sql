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
		Dynamic_Description
	)
VALUES
	(
		140,
		'restart',
		NULL,
		'pipe,skip-banphrase,system,whitelist',
		'Restarts the bot by killing the process and letting PM2 restart it.',
		0,
		NULL,
		NULL,
		'(async function restart () {
	setTimeout(() => process.abort(), 1000);
	return { reply: \"Restarting...\" };
})',
		NULL
	)