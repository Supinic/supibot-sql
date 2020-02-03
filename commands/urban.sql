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
		29,
		'urban',
		NULL,
		'Fetches the top definition of a given term from UrbanDictionary. You can append \"index:#\" at the end to access definitions that aren\'t first in the search',
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
		'(async function urban (context, ...args) {
	if (args.length === 0) {
		return {
			reply: \"No term has been provided!\",
			cooldown: {
				length: 2500
			}
		};
	}

	let index = 0;
	for (let i = args.length - 1; i >= 0; i--) {
		const token = args[i];
		if (/index:\\d+/.test(token)) {
			index = Number(token.split(\":\")[1]);
			args.splice(i, 1);
		}
	}

	let data = null;
	const params = new sb.URLParams().set(\"term\", args.join(\" \"));
	try {
		data = JSON.parse(await sb.Utils.request({
			rejectUnauthorized: false,
			uri: `https://api.urbandictionary.com/v0/define?${params.toString()}`
		}));
	}
	catch (e) {
		console.warn(\"Urban is down\", e);
		return { reply: \"Urban API returned an error :(\" };
	}

	if (!data.list || data.result_type === \"no_results\") {
		return { reply: \"No results found!\" };
	}

	const item = data.list.filter(i => i.word.toLowerCase() === args.join(\" \").toLowerCase())[index];
	if (!item) {
		return { reply: \"There is no definition with that index!\" };
	}

	const thumbs = \"(+\" + item.thumbs_up + \"/-\" + item.thumbs_down + \")\";
	const example = (item.example)
		? (\" - Example: \" + item.example)
		: \"\";

	return {
		reply: thumbs + \" \" + (item.definition + example).replace(/[\\][]/g, \"\")
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function urban (context, ...args) {
	if (args.length === 0) {
		return {
			reply: \"No term has been provided!\",
			cooldown: {
				length: 2500
			}
		};
	}

	let index = 0;
	for (let i = args.length - 1; i >= 0; i--) {
		const token = args[i];
		if (/index:\\d+/.test(token)) {
			index = Number(token.split(\":\")[1]);
			args.splice(i, 1);
		}
	}

	let data = null;
	const params = new sb.URLParams().set(\"term\", args.join(\" \"));
	try {
		data = JSON.parse(await sb.Utils.request({
			rejectUnauthorized: false,
			uri: `https://api.urbandictionary.com/v0/define?${params.toString()}`
		}));
	}
	catch (e) {
		console.warn(\"Urban is down\", e);
		return { reply: \"Urban API returned an error :(\" };
	}

	if (!data.list || data.result_type === \"no_results\") {
		return { reply: \"No results found!\" };
	}

	const item = data.list.filter(i => i.word.toLowerCase() === args.join(\" \").toLowerCase())[index];
	if (!item) {
		return { reply: \"There is no definition with that index!\" };
	}

	const thumbs = \"(+\" + item.thumbs_up + \"/-\" + item.thumbs_down + \")\";
	const example = (item.example)
		? (\" - Example: \" + item.example)
		: \"\";

	return {
		reply: thumbs + \" \" + (item.definition + example).replace(/[\\][]/g, \"\")
	};
})'