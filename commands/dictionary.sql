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
		23,
		'dictionary',
		'[\"define\", \"def\", \"dict\"]',
		'ping,pipe',
		'Fetches the dictionary definition of a word. You can use \"lang:\" to specifiy a language, and if there are multiple definitions, you can add \"index:#\" with a number to access specific definition indexes.',
		10000,
		NULL,
		NULL,
		'(async function dictionary (context, ...args) {
	if (args.length === 0) {
		return {
			success: false,
			reply: \"No word provided!\"
		};
	}

	let index = 0;
	let language = \"en\";
	for (let i = args.length - 1; i >= 0; i--) {
		const token = args[i];
		if (token.includes(\"lang:\")) {
			language = sb.Utils.languageISO.getCode(token.split(\":\")[1]);
			args.splice(i, 1);
		}
		else if (token.includes(\"index:\")) {
			index = Number(token.split(\":\")[1]);
			args.splice(i, 1);
		}
	}

	if (!language) {
		return {
			success: false,
			reply: \"Invalid language provided!\"
		};
	}

	const word = encodeURIComponent(args.shift());
	const { statusCode, body: data } = await sb.Got({
		url: `https://api.dictionaryapi.dev/api/v1/entries/${language}/${word}`,
		throwHttpErrors: false,
		responseType: \"json\"
	});

	if (statusCode !== 200) {
		return {
			success: false,
			reply: data.message
		};
	}
	
	const items = Object.entries(data[0].meaning).flatMap(([type, value]) => value.map(item => ({ type, definition: item.definition })))
	if (items.length === 0) {		
		return {
			reply: `${data[0].word} (${data[0].phonetic}) - no word meaning has been found!`
		};
	}

	const result = items[index];
	if (!result) {
		return {
			success: false,
			reply: `There is no item with that index! Maximum index: ${items.length}`
		};
	}

	return {
		reply: `${data[0].word} (${result.type}): ${result.definition}`
	};
})',
		NULL,
		'supinic/supibot-sql'
	)