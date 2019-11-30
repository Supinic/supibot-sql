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
		37,
		'news',
		NULL,
		'Fetches short articles. You can use a 2 character ISO code to get country specific news, or any other word as a search query.',
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
		'(async function news (context, ...rest) {
	let params = new sb.URLParams().set(\"language\", \"en\");

	if (rest[0] && sb.ExtraNews.check(rest[0])) {
		return { 
			reply: await sb.ExtraNews.fetch(rest[0])
		};
	}
	else if (/^[A-Z]{2}$/i.test(rest[0])) {
		params.unset(\"language\")
			.set(\"country\", rest.shift().toLowerCase());
	}

	const url = \"https://newsapi.org/v2/top-headlines?\";
	if (rest.length !== 0) {
		params.set(\"q\", sb.Utils.argsToFixedURL(rest));
	}
	else if (!params.has(\"country\")) {
		params.set(\"country\", \"US\");
	}

	const data = JSON.parse(await sb.Utils.request({
		url: url + String(params).replace(/%2b/gi, \"+\"),
		headers: {
			Authorization: \"Bearer \" + sb.Config.get(\"API_NEWSAPI_ORG\")
		}
	}));

	if (!data.articles) {
		return { 
			reply: \"No news data returned!\"
		};
	}
	else if (data.articles.length === 0) {
		return { 
			reply: \"No relevant articles found!\"
		};
	}

	const headline = sb.Utils.randArray(data.articles);
	const title = sb.Utils.fixHTML(headline.title || \"\");
	const text = title + (title ? \". \" : \"\") + sb.Utils.removeHTML(sb.Utils.fixHTML(headline.description || \"\"));

	return { 
		reply: text 
	};
})',
		NULL,
		'async (prefix) => {
	const extraNews = (await sb.Query.getRecordset(rs => rs
		.select(\"Code\", \"Language\", \"URL\", \"Helpers\")
		.from(\"data\", \"Extra_News\")
		.orderBy(\"Code ASC\")
	)).map(i => {
		const helpers = i.Helpers ? JSON.parse(i.Helpers).join(\", \") : \"N/A\";
		return `<tr><td>${i.Code.toUpperCase()}</td><td>${sb.Utils.capitalize(i.Language)}</td><td>${helpers}</td></tr>`;
	}).join(\"\");
	
	return [
		\"Fetches short random articles, based on the argument(s) provided\",
		\"No arguments = a topic-independent English (US) article\",
		\"Two-letter ISO code of a country = topic-independent article from that country\'s news\",
		\"Any word(s) that are not above country codes = English (US) article that contains given word(s)\",
		\"Combination of country code (must be first) and any word(s) = that country\'s news\' article with given word(s)\",		
		\"=\".repeat(30),
		prefix + \"news => Johnson & Johnson ordered to pay man $8 BILLION over drug causing him to grow breasts - RT. Johnson & Johnson ordered to pay man $8 BILLION over drug causing him to grow breasts\",
		prefix + \"news FI => Budjettivääntö jatkuu eduskunnassa – IS lähettää keskustelun suorana (Ilta-Sanomat)\",
		prefix + \"news Germany => ...\",
		prefix + \"news Donald Trump => ...\",
		\"=\".repeat(30),
		\"Specific country news were generously provided:\",
		\"<table><thead><th>Code</th><th>Language</th><th>Helpers</th></thead>\" + extraNews + \"</table>\"
	];
}'
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function news (context, ...rest) {
	let params = new sb.URLParams().set(\"language\", \"en\");

	if (rest[0] && sb.ExtraNews.check(rest[0])) {
		return { 
			reply: await sb.ExtraNews.fetch(rest[0])
		};
	}
	else if (/^[A-Z]{2}$/i.test(rest[0])) {
		params.unset(\"language\")
			.set(\"country\", rest.shift().toLowerCase());
	}

	const url = \"https://newsapi.org/v2/top-headlines?\";
	if (rest.length !== 0) {
		params.set(\"q\", sb.Utils.argsToFixedURL(rest));
	}
	else if (!params.has(\"country\")) {
		params.set(\"country\", \"US\");
	}

	const data = JSON.parse(await sb.Utils.request({
		url: url + String(params).replace(/%2b/gi, \"+\"),
		headers: {
			Authorization: \"Bearer \" + sb.Config.get(\"API_NEWSAPI_ORG\")
		}
	}));

	if (!data.articles) {
		return { 
			reply: \"No news data returned!\"
		};
	}
	else if (data.articles.length === 0) {
		return { 
			reply: \"No relevant articles found!\"
		};
	}

	const headline = sb.Utils.randArray(data.articles);
	const title = sb.Utils.fixHTML(headline.title || \"\");
	const text = title + (title ? \". \" : \"\") + sb.Utils.removeHTML(sb.Utils.fixHTML(headline.description || \"\"));

	return { 
		reply: text 
	};
})'