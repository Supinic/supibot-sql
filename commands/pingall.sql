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
		172,
		'pingall',
		NULL,
		NULL,
		'Attempts to check all channel bots by using their ping commands.',
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
		'(async function pingAll (context) {
	const bots = await sb.Query.getRecordset(rs => rs
		.select(\"Bot_Alias\", \"Prefix\", \"Prefix_Space\")
		.from(\"bot_data\", \"Bot\")
		.where(\"Prefix IS NOT NULL\")
		.where(\"Bot_Alias <> %n\", sb.Config.get(\"SELF_ID\"))
	);

	for (const bot of bots) {
		sb.Master.send(bot.Prefix + (bot.Prefix_Space ? \" \" : \"\") + \"ping\", context.channel);
	}
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function pingAll (context) {
	const bots = await sb.Query.getRecordset(rs => rs
		.select(\"Bot_Alias\", \"Prefix\", \"Prefix_Space\")
		.from(\"bot_data\", \"Bot\")
		.where(\"Prefix IS NOT NULL\")
		.where(\"Bot_Alias <> %n\", sb.Config.get(\"SELF_ID\"))
	);

	for (const bot of bots) {
		sb.Master.send(bot.Prefix + (bot.Prefix_Space ? \" \" : \"\") + \"ping\", context.channel);
	}
})'