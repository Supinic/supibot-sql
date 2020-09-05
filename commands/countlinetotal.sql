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
		8,
		'countlinetotal',
		'[\"clt\"]',
		'mention,pipe,skip-banphrase,system,whitelist',
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

	const history = await sb.Query.getRecordset(rs => rs
		.select(\"Executed\", \"Result\")
		.from(\"chat_data\", \"Command_Execution\")
		.where(\"Command = %n\", this.ID)
		.where(\"Result <> %s\", \"\")
		.orderBy(\"Executed ASC\")
		.limit(1)
		.single()
	);

	const days = (sb.Date.now() - history.Executed) / 864.0e5;
	const originalSize = Number(history.Result.match(/([\\d.]+) GB of space/)[1]);
	const currentSize = sb.Utils.round(data.Bytes / (10 ** 9), 3);

	const rate = sb.Utils.round((currentSize - originalSize) / days, 3);
	const fillDate = new sb.Date().addDays((220 - currentSize) / rate); // 238 GB minus an estimate of ~18GB of other stuff
	const megabytesPerHour = sb.Utils.round(rate * 1024 / 24, 3);

	return {
		reply: sb.Utils.tag.trim `
			Currently logging ${preciseLines} lines in total across all channels,
			taking up ~${currentSize} GB of space.
			Lines are added at a rate of ~${megabytesPerHour} MB/hr.
			Supibot\'s hard drive will run out of space approximately on ${fillDate.format(\"Y-m-d\")}.
		`
	};
})',
		NULL,
		'supinic/supibot-sql'
	)