INSERT INTO
	`chat_data`.`Command`
	(
		ID,
		Name,
		Aliases,
		Flags,
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
		Owner_Override,
		Archived,
		Static_Data,
		Code,
		Examples,
		Dynamic_Description
	)
VALUES
	(
		29,
		'urban',
		NULL,
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
		0,
		NULL,
		'(async function urban (context, ...args) {
	if (args.length === 0) {
		return {
			success: false,
			reply: \"No term has been provided!\",
			cooldown: 2500
		};
	}

	let index = null;
	for (let i = args.length - 1; i >= 0; i--) {
		const token = args[i];
		if (/index:\\d+/.test(token)) {
			index = Number(token.split(\":\")[1]);
			args.splice(i, 1);
		}
	}

	const data = await sb.Got({
		url: \"https://api.urbandictionary.com/v0/define\",
		searchParams: new sb.URLParams()
			.set(\"term\", args.join(\" \"))
			.toString()
	}).json();

	if (!data.list || data.result_type === \"no_results\") {
		return {
			success: false,
			reply: \"No results found!\"
		};
	}

	const items = data.list.filter(i => i.word.toLowerCase() === args.join(\" \").toLowerCase());
	const item = items[index ?? 0];
	if (!item) {
		return { 
			success: false,
			reply: `No definition with index ${index ?? 0}! Maximum available: ${items.length - 1}.`
		};
	}

	let extra = \"\";
	if (items.length > 1 && index === null) {
		extra = `(${items.length - 1} extra definitons)`
	}

	const thumbs = \"(+\" + item.thumbs_up + \"/-\" + item.thumbs_down + \")\";
	const example = (item.example)
		? ` - Example: ${item.example}`
		: \"\";
	const content = (item.definition + example).replace(/[\\][]/g, \"\");

	return {
		reply: `${extra} ${thumbs} ${content}` 
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function urban (context, ...args) {
	if (args.length === 0) {
		return {
			success: false,
			reply: \"No term has been provided!\",
			cooldown: 2500
		};
	}

	let index = null;
	for (let i = args.length - 1; i >= 0; i--) {
		const token = args[i];
		if (/index:\\d+/.test(token)) {
			index = Number(token.split(\":\")[1]);
			args.splice(i, 1);
		}
	}

	const data = await sb.Got({
		url: \"https://api.urbandictionary.com/v0/define\",
		searchParams: new sb.URLParams()
			.set(\"term\", args.join(\" \"))
			.toString()
	}).json();

	if (!data.list || data.result_type === \"no_results\") {
		return {
			success: false,
			reply: \"No results found!\"
		};
	}

	const items = data.list.filter(i => i.word.toLowerCase() === args.join(\" \").toLowerCase());
	const item = items[index ?? 0];
	if (!item) {
		return { 
			success: false,
			reply: `No definition with index ${index ?? 0}! Maximum available: ${items.length - 1}.`
		};
	}

	let extra = \"\";
	if (items.length > 1 && index === null) {
		extra = `(${items.length - 1} extra definitons)`
	}

	const thumbs = \"(+\" + item.thumbs_up + \"/-\" + item.thumbs_down + \")\";
	const example = (item.example)
		? ` - Example: ${item.example}`
		: \"\";
	const content = (item.definition + example).replace(/[\\][]/g, \"\");

	return {
		reply: `${extra} ${thumbs} ${content}` 
	};
})'