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
		168,
		'reset',
		NULL,
		'mention,pipe,system',
		'Tracks your last \"\"\"reset\"\"\".',
		30000,
		NULL,
		NULL,
		'(async function reset (context, ...args) { 
	const message = args.join(\" \") || null;
	const existing = await sb.Query.getRecordset(rs => rs
		.select(\"Timestamp\")
		.from(\"data\", \"Reset\")
		.where(\"User_Alias = %n\", context.user.ID)
		.orderBy(\"ID DESC\")
		.limit(1)
		.single()
	);

	const row = await sb.Query.getRow(\"data\", \"Reset\");
	row.setValues({
		User_Alias: context.user.ID,
		Reason: message
	});

	await row.save();

	if (existing) {
		const delta = sb.Utils.timeDelta(existing.Timestamp);
		return {
			reply: \"Successfully noted. Your last reset was \" + delta
		};
	}
	else {
		return {
			reply: \"Successfully noted. This your first reset.\"
		};
	}
})',
		NULL,
		'supinic/supibot-sql'
	)