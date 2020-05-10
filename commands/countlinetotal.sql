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
		Dynamic_Description
	)
VALUES
	(
		8,
		'countlinetotal',
		'[\"clt\"]',
		'ping,pipe,skip-banphrase,system,whitelist',
		'Fetches the amount of data lines from ALL the log tables, including the total size.',
		0,
		NULL,
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
		NULL
	)