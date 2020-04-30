INSERT INTO
	`chat_data`.`Command`
	(
		ID,
		Name,
		Aliases,
		Flags,
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
		Owner_Override,
		Archived,
		Static_Data,
		Code,
		Examples,
		Dynamic_Description
	)
VALUES
	(
		140,
		'restart',
		NULL,
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
		0,
		NULL,
		'(async function restart () {
	setTimeout(() => process.abort(), 1000);
	return { reply: \"Restarting...\" };
})',
		NULL,
		NULL
	)