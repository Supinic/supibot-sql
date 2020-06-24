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
		'developer,pipe,skip-banphrase,whitelist',
		'Attempts to check all channel bots by using their ping commands.',
		0,
		NULL,
		NULL,
		'(async function pingAll (context) {
	const bots = await sb.Query.getRecordset(rs => rs
		.select(\"Bot_Alias\", \"Prefix\", \"Prefix_Space\")
		.from(\"bot_data\", \"Bot\")
		.where(\"Prefix IS NOT NULL\")
		.where(\"Prefix <> %s\", sb.Command.prefix)
	);

	for (const bot of bots) {
		const space = bot.Prefix_Space ? \" \" : \"\";
		context.channel.send(`${bot.Prefix}${space}ping`);
	}

	return null;
})',
		NULL,
		'supinic/supibot-sql'
	)