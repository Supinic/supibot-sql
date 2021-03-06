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
		4,
		'wiki',
		NULL,
		'mention,pipe',
		'Fetches the headline of the first article found according to user query. Watch out, articles might be case sensitive.',
		15000,
		NULL,
		NULL,
		'(async function wiki (context, ...args) {
	if (args.length === 0) {
		return {
			reply: \"No article specified!\",
			cooldown: { length: 2500 }
		};
	}

	let language = \"en\";
	for (let i = args.length - 1; i >= 0; i--) {
		const token = args[i];
		if (/lang:\\w+/.test(token)) {
			language = sb.Utils.languageISO.getCode(token.split(\":\")[1]);
			if (language === null) {
				return {
					reply: \"Invalid language provided!\",
					cooldown: { length: 1000 }
				};
			}

			language = language.toLowerCase();
			args.splice(i, 1);
		}
	}

	const query = args.join(\" \").split(/(?:(\\W))/).filter(Boolean).map(i => i[0].toUpperCase() + i.slice(1)).join(\"\");
	const rawData = await sb.Got({
		url: `https://${language}.wikipedia.org/w/api.php`,
		searchParams: new sb.URLParams()
			.set(\"format\", \"json\")
			.set(\"action\", \"query\")
			.set(\"prop\", \"extracts\")
			.set(\"redirects\", \"1\")
			.set(\"titles\", query)
			.toString()
	}).json();

	const data = rawData.query.pages;
	const key = Object.keys(data)[0];
	if (key === \"-1\") {
		return { reply: \"No results found!\" };
	}
	else {
		let link = \"\";
		if (!context.channel || context.channel.Links_Allowed === true) {
			link = `https://${language}.wikipedia.org/?curid=${key}`;
		}

		return {
			reply: link + \" \" + data[key].title + \": \" + sb.Utils.removeHTML(data[key].extract)
		};
	}
})',
		'async (prefix) => {
	return [
		\"Finds the summary of a given Wikipedia article.\",
		\"Arguments are the name of the article you want to find.\",
		\"\",
		prefix + \"wiki uncanny valley => In aesthetics, the uncanny valley is a hypothesized relationship between the degree...\",
		\"...\"
	];
}',
		'supinic/supibot-sql'
	)