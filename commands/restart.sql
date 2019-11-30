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
		140,
		'restart',
		NULL,
		'Restarts the bot by killing the process and letting PM2 restart it.',
		0,
		0,
		1,
		1,
		1,
		NULL,
		0,
		0,
		0,
		0,
		1,
		0,
		'async () => {
	setTimeout(() => process.kill(process.pid), 2000);
	return { reply: \"Restarting...\" };
}',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async () => {
	setTimeout(() => process.kill(process.pid), 2000);
	return { reply: \"Restarting...\" };
}'