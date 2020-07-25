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
		29,
		'urban',
		NULL,
		'mention,pipe',
		'Fetches the top definition of a given term from UrbanDictionary. You can append \"index:#\" at the end to access definitions that aren\'t first in the search',
		10000,
		NULL,
		'({
	timeout: 10000
})',
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

	let data = null;
	try {
		data = await sb.Got({
			retry: 0,
			timeout: this.staticData.timeout,
			url: \"https://api.urbandictionary.com/v0/define\",
			searchParams: new sb.URLParams()
				.set(\"term\", args.join(\" \"))
				.toString()
		}).json();
	}
	catch (e) {
		if (e instanceof sb.Got.TimeoutError) {
			return {
				success: false,
				reply: `Urban command timed out after ${this.staticData.timeout / 1000} seconds!`
			};
		}
		else {
			throw e;
		}
	}

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
			reply: (items.length === 0)
				? `No such definition exists!`
				: `No definition with index ${index ?? 0}! Maximum available: ${items.length - 1}.`
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
		'supinic/supibot-sql'
	)