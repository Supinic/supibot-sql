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
		101,
		'beefact',
		NULL,
		NULL,
		'Posts a random fact about bees.',
		10000,
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
		0,
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
		'No arguments.

$beefact',
		NULL
	)