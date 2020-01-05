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
		191,
		'content',
		NULL,
		'Shows how many suggestions there are Uncategorized and New - basically showing how much content I have for the next stream.',
		30000,
		0,
		0,
		0,
		0,
		NULL,
		0,
		0,
		0,
		1,
		1,
		0,
		'(async function content () {
	const data = await sb.Query.getRecordset(rs => rs
		.select(\"COUNT(*) AS Count\")
		.from(\"data\", \"Suggestion\")
		.where(\"Category = %s\", \"Uncategorized\")
		.where(\"Status = %s\", \"New\")
		.single()
	);

	return {
		reply: \"There are \" + data.Count + \" content suggestions left!\"
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function content () {
	const data = await sb.Query.getRecordset(rs => rs
		.select(\"COUNT(*) AS Count\")
		.from(\"data\", \"Suggestion\")
		.where(\"Category = %s\", \"Uncategorized\")
		.where(\"Status = %s\", \"New\")
		.single()
	);

	return {
		reply: \"There are \" + data.Count + \" content suggestions left!\"
	};
})'