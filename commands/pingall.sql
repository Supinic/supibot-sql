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
		172,
		'pingall',
		NULL,
		'pipe,skip-banphrase,system,whitelist',
		'Attempts to check all channel bots by using their ping commands.',
		0,
		NULL,
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
		'supinic/supibot-sql'
	)