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
		'ping,pipe',
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

	if (!event) {
		const dateString = this.staticData.formatter.format(date);
		const { body: data } = await sb.Got({
			responseType: \"json\",
			url: `https://en.wikipedia.org/w/api.php`,
			searchParams: new sb.URLParams()
				.set(\"format\", \"json\")
				.set(\"action\", \"query\")
				.set(\"prop\", \"extracts\")
				.set(\"redirects\", \"1\")
				.set(\"titles\", dateString)
				.toString()
		});

		const pageID = Object.keys(data.query.pages)[0];
		const { extract } = data.query.pages[pageID];
		const $ = sb.Utils.cheerio(extract);
		const list = Array.from($(\"h2\"))
			.find(i => i.firstChild?.attribs?.id === \"Events\")
			.nextSibling
			.nextSibling
			.children
			.map(i => $(i)?.text() ?? null)
			.filter(Boolean);

		const batch = await sb.Query.getBatch(\"data\", \"Historic_Event\", [\"Year\", \"Month\", \"Day\", \"Text\"]);
		for (const string of list) {
			const [yearString, eventString] = string.split(\" – \");
			if (!eventString) {
				continue;
			}

			let year = Number(yearString);
			if (yearString.includes(\"AD\")) {
				year = Number(yearString.replace(\"AD\", \"\"));
			}
			else if (yearString.includes(\"BC\")) {
				year = Number(yearString.replace(/BCE?/, \"\"));
				year = -year;
			}

			batch.add({
				Text: eventString.trim(),
				Year: year,
				Month: month,
				Day: day
			});
		}

		event = sb.Utils.randArray(batch.records);
		await batch.insert();
	}

	return {
		reply: `Year ${event.Year}: ${event.Text}`
	};
})
',
		NULL,
		'supinic/supibot-sql'
	)