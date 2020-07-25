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
		234,
		'randomhistoricevent',
		'[\"rhe\"]',
		'mention,pipe',
		NULL,
		10000,
		NULL,
		'({
	formatter: new Intl.DateTimeFormat(\"en-GB\", {
		month: \"long\",
		day: \"numeric\"
	})
})',
		'(async function randomHistoricEvent (context, ...args) {
	const date = (args.length > 0)
		? new sb.Date(args.join(\" \"))
		: new sb.Date();

	if (!date.valueOf()) {
		return {
			success: false,
			reply: `Invalid date provided!`
		};
	}

	const { day, month } = date;
	let event = await sb.Query.getRecordset(rs => rs
		.select(\"Year\", \"Text\")
		.from(\"data\", \"Historic_Event\")
		.where(\"Day = %n\", day)
		.where(\"Month = %n\", month)
		.orderBy(\"RAND()\")
		.limit(1)
		.single()
	);

	return {
		reply: `Year ${event.Year}: ${event.Text}`
	};
})',
		NULL,
		'supinic/supibot-sql'
	)