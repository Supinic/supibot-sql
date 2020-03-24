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
		4,
		'wiki',
		NULL,
		'Fetches the headline of the first article found according to user query. Watch out, articles might be case sensitive.',
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

	const rawData = await sb.Got({
		url: `https://${language}.wikipedia.org/w/api.php`,
		searchParams: new sb.URLParams()
			.set(\"format\", \"json\")
			.set(\"action\", \"query\")
			.set(\"prop\", \"extracts\")
			.set(\"redirects\", \"1\")
			.set(\"titles\", args.map(i => sb.Utils.capitalize(i)).join(\" \"))
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
		NULL,
		'async (prefix) => {
	return [
		\"Finds the summary of a given Wikipedia article.\",
		\"Arguments are the name of the article you want to find.\",
		\"\",
		prefix + \"wiki uncanny valley => In aesthetics, the uncanny valley is a hypothesized relationship between the degree...\",
		\"...\"
	];
}'
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function wiki (context, ...args) {
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

	const rawData = await sb.Got({
		url: `https://${language}.wikipedia.org/w/api.php`,
		searchParams: new sb.URLParams()
			.set(\"format\", \"json\")
			.set(\"action\", \"query\")
			.set(\"prop\", \"extracts\")
			.set(\"redirects\", \"1\")
			.set(\"titles\", args.map(i => sb.Utils.capitalize(i)).join(\" \"))
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
})'