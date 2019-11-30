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
		'async (context, ...args) => {
	const message = args.join(\" \");
	if (!message) {
		return { reply: \"No search text provided!\" };
	}

	const params = new sb.URLParams()
		.set(\"order\", \"desc\")
		.set(\"sort\", \"relevance\")
		.set(\"site\", \"stackoverflow\")
		.set(\"q\", message);

	const rawData = await sb.Utils.request({
		method: \"GET\",
		url: `https://api.stackexchange.com/2.2/search/advanced?${params.toString()}`,
		gzip: true,
		headers: {
			\"User-Agent\": \"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36 OPR/62.0.3331.116\"
		}
	});

	const data = JSON.parse(rawData);
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
}',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async (context, ...args) => {
	const message = args.join(\" \");
	if (!message) {
		return { reply: \"No search text provided!\" };
	}

	const params = new sb.URLParams()
		.set(\"order\", \"desc\")
		.set(\"sort\", \"relevance\")
		.set(\"site\", \"stackoverflow\")
		.set(\"q\", message);

	const rawData = await sb.Utils.request({
		method: \"GET\",
		url: `https://api.stackexchange.com/2.2/search/advanced?${params.toString()}`,
		gzip: true,
		headers: {
			\"User-Agent\": \"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36 OPR/62.0.3331.116\"
		}
	});

	const data = JSON.parse(rawData);
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
}'