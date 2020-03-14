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
		Static_Data,
		Code,
		Examples,
		Dynamic_Description
	)
VALUES
	(
		168,
		'reset',
		NULL,
		'Tracks your last \"\"\"reset\"\"\".',
		30000,
		0,
		1,
		0,
		0,
		NULL,
		0,
		0,
		0,
		1,
		1,
		0,
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
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function reset (context, ...args) { 
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
})'