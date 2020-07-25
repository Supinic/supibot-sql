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
		101,
		'beefact',
		NULL,
		'mention,pipe',
		'Posts a random fact about bees.',
		10000,
		NULL,
		NULL,
		'(async function beeFact () {
	const fact = await sb.Query.getRecordset(rs => rs
		.select(\"Text\")
		.from(\"data\", \"Fun_Fact\")
		.where(\"Tag = %s\", \"Bees\")
		.orderBy(\"RAND()\")
		.limit(1)
		.single()
	);

	return { reply: fact.Text };
})',
		NULL,
		'supinic/supibot-sql'
	)