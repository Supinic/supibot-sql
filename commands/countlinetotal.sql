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
		8,
		'countlinetotal',
		'[\"clt\"]',
		NULL,
		'Fetches the amount of data lines from ALL the log tables, including the total size.',
		0,
		0,
		1,
		1,
		1,
		NULL,
		0,
		0,
		0,
		1,
		1,
		0,
		0,
		NULL,
		'(async function countLineTotal () {
	let preciseLines = 0;
	for (const channel of sb.Channel.data.filter(i => i.Type !== \"Inactive\")) {
		const rs = await sb.Query.getRecordset(rs => rs
			.select(\"MAX(ID) AS Total\")
			.from(\"chat_line\", channel.getDatabaseName())
			.single()
		);

		if (!rs) {
			console.warn(\"countlinetotal: No ID found\", channel.Name);
			continue;
		}

		preciseLines += rs.Total;
	}

	const data = await sb.Query.getRecordset(rs => rs
		.select(\"(SUM(DATA_LENGTH) + SUM(INDEX_LENGTH)) AS Bytes\")
		.from(\"INFORMATION_SCHEMA\", \"TABLES\")
		.where(\"TABLE_SCHEMA = %s\", \"chat_line\")
		.single()
	);

	return {
		reply: \"Currently logging \" + preciseLines + \" lines in total across all channels, taking up approximately \" + sb.Utils.round(data.Bytes / 1073741824, 3) + \" GB of space.\"
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function countLineTotal () {
	let preciseLines = 0;
	for (const channel of sb.Channel.data.filter(i => i.Type !== \"Inactive\")) {
		const rs = await sb.Query.getRecordset(rs => rs
			.select(\"MAX(ID) AS Total\")
			.from(\"chat_line\", channel.getDatabaseName())
			.single()
		);

		if (!rs) {
			console.warn(\"countlinetotal: No ID found\", channel.Name);
			continue;
		}

		preciseLines += rs.Total;
	}

	const data = await sb.Query.getRecordset(rs => rs
		.select(\"(SUM(DATA_LENGTH) + SUM(INDEX_LENGTH)) AS Bytes\")
		.from(\"INFORMATION_SCHEMA\", \"TABLES\")
		.where(\"TABLE_SCHEMA = %s\", \"chat_line\")
		.single()
	);

	return {
		reply: \"Currently logging \" + preciseLines + \" lines in total across all channels, taking up approximately \" + sb.Utils.round(data.Bytes / 1073741824, 3) + \" GB of space.\"
	};
})'