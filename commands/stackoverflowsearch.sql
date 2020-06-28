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
		149,
		'stackoverflowsearch',
		'[\"stackoverflow\", \"sos\"]',
		'ping,pipe',
		'Searches SO for relevant questions and answers.',
		15000,
		NULL,
		NULL,
		'(async function stackOverflowSearch (context, ...args) {
	const message = args.join(\" \");
	if (!message) {
		return { reply: \"No search text provided!\" };
	}

	const data = await sb.Got({
		url: \"https://api.stackexchange.com/2.2/search/advanced\",
		gzip: true,
		searchParams: new sb.URLParams()
			.set(\"order\", \"desc\")
			.set(\"sort\", \"relevance\")
			.set(\"site\", \"stackoverflow\")
			.set(\"q\", message)
			.toString()
	}).json();
	
	if (data.quota_remaining === 0) {
		return { reply: \"Daily quota exceeded! :(\" };
	}
	else if (data.items.length === 0) {
		return { reply: \"No relevant questions found!\" };
	}

	const item = data.items[0];
	return {
		reply: [
			item.title,
			\"(score: \" + item.score + \", answers: \" + item.answer_count + \")\",
			\"asked by \" + item.owner.display_name,
			sb.Utils.timeDelta(new sb.Date(item.creation_date * 1000)),
			\"and last active\",
			sb.Utils.timeDelta(new sb.Date(item.last_activity_date * 1000)) + \".\",
			\"https://stackoverflow.com/questions/\" + item.question_id
		].join(\" \")
	};
})',
		NULL,
		'supinic/supibot-sql'
	)