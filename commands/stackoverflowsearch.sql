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
		149,
		'stackoverflowsearch',
		'[\"sos\"]',
		'Searches SO for relevant questions and answers.',
		15000,
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
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function stackOverflowSearch (context, ...args) {
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
})'