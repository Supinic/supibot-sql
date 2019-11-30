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
		'async (extra, ...args) => {
	if (args.length === 0) {
		return { 
			reply: \"No term has been provided!\",
			meta: { skipCooldown: true }
		};
	}

	let index = 0;
	const last = args[args.length - 1];
	if (/index:(\\d+)/.test(last)) {
		index = Number(args.pop().split(\":\")[1]);
	}

	const url = \"https://api.urbandictionary.com/v0/define?term=\" + sb.Utils.argsToFixedURL(args);
	

	let data = null;

	try {
		data = JSON.parse(await sb.Utils.request(url));
	}
	catch (e) {
		console.warn(\"Urban is down\", e);
		return { reply: \"Urban API returned an error :(\" };
	}
	if (!data.list || data.result_type === \"no_results\") {
		sb.SystemLogger.send(\"Command.Other\", JSON.stringify(data));
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
}',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async (extra, ...args) => {
	if (args.length === 0) {
		return { 
			reply: \"No term has been provided!\",
			meta: { skipCooldown: true }
		};
	}

	let index = 0;
	const last = args[args.length - 1];
	if (/index:(\\d+)/.test(last)) {
		index = Number(args.pop().split(\":\")[1]);
	}

	const url = \"https://api.urbandictionary.com/v0/define?term=\" + sb.Utils.argsToFixedURL(args);
	

	let data = null;

	try {
		data = JSON.parse(await sb.Utils.request(url));
	}
	catch (e) {
		console.warn(\"Urban is down\", e);
		return { reply: \"Urban API returned an error :(\" };
	}
	if (!data.list || data.result_type === \"no_results\") {
		sb.SystemLogger.send(\"Command.Other\", JSON.stringify(data));
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
}'