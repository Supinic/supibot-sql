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
		37,
		'news',
		NULL,
		'ping,pipe',
		'Fetches short articles. You can use a 2 character ISO code to get country specific news, or any other word as a search query.',
		10000,
		NULL,
		NULL,
		'(async function news (context, ...rest) {
	const params = new sb.URLParams().set(\"language\", \"en\");
	if (rest[0] && sb.ExtraNews.check(rest[0])) {
		const code = rest.shift();
		const article = await sb.ExtraNews.fetch(code, rest.join(\" \") || null);

		if (!article) {
			return {
				reply: \"No relevant articles found!\"
			};
		}

		const { content = \"\", title, published } = article;
		let delta = \"\";
		if (published.valueOf()) {
			delta = \"(published \" + sb.Utils.timeDelta(published) + \")\";
		}

		return {
			reply: sb.Utils.removeHTML(`${title} ${content ?? \"\"} ${delta}`)
		};
	}
	else if (/^[A-Z]{2}$/i.test(rest[0])) {
		params.unset(\"language\").set(\"country\", rest.shift().toLowerCase());
	}
	else if (/source:\\w+/i.test(rest[0])) {
		params.unset(\"language\").set(\"sources\", rest.shift().split(\":\")[1]);
	}

	if (rest.length !== 0) {
		params.set(\"q\", rest.join(\" \"));
	}
	else if (!params.has(\"country\") && !params.has(\"sources\")) {
		params.set(\"country\", \"US\");
	}

	const data = await sb.Got({
		url: \"https://newsapi.org/v2/top-headlines\",
		searchParams: params.toString(),
		headers: {
			Authorization: \"Bearer \" + sb.Config.get(\"API_NEWSAPI_ORG\")
		}
	}).json();

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

	const { description, publishedAt, title } = sb.Utils.randArray(data.articles);
	const delta = (publishedAt)
		? \"(published \" + sb.Utils.timeDelta(new sb.Date(publishedAt)) + \")\"
		: \"\";

	return {
		reply: sb.Utils.removeHTML(`${title} ${description ?? \"\"} ${delta}`)
	};
})',
		'async (prefix) => {
	const { sources } = await sb.Got({
		url: \"https://newsapi.org/v2/sources\",
		headers: {
			Authorization: \"Bearer \" + sb.Config.get(\"API_NEWSAPI_ORG\")
		}
	}).json();

	const extraNews = (await sb.Query.getRecordset(rs => rs
		.select(\"Code\", \"Language\", \"URL\", \"Helpers\")
		.from(\"data\", \"Extra_News\")
		.orderBy(\"Code ASC\")
	)).map(i => {
		const helpers = i.Helpers ? JSON.parse(i.Helpers).join(\", \") : \"N/A\";
		return `<tr><td>${i.Code.toUpperCase()}</td><td>${sb.Utils.capitalize(i.Language)}</td><td>${helpers}</td></tr>`;
	}).join(\"\");
	
	return [
		\"Fetches short news articles.\",
		\"\",

		`<code>${prefix}news</code>`,
		\"(worldwide news in english)\",
		\"\",
	
		`<code>${prefix}news (text to search)</code>`,
		\"(worldwide news in english, that contain the text you searched for\",
		\"\",
		
		`<code>${prefix}news (two-letter country code)</code>`,
		\"(country-specific news)\",
		\"\",

		`<code>${prefix}news source:(source)</code>`,
		\"news from your selected news source. check the list of sources below.\",
		\"\",

		`<code>${prefix}news (two-letter country code) (text to search for)</code>`,
		\"(country-specific news that contain the text you searched for)\",
		\"\",

		`<code>${prefix}news (special combination)</code>`,
		\"(special news, usually country-specific. consult table below)\",
		\"\",

		\"The following are special codes. Those were often \'helped\' by people.\",
		\"<table><thead><th>Code</th><th>Language</th><th>Helpers</th></thead>\" + extraNews + \"</table>\",
		\"\",

		\"List of usable sources:\",
		\"<ul>\" + sources.map(i => `<li><a href=\"${i.url}\">${i.id}</a></li>`).join(\"\") + \"</ul>\"
	];
}'
	)