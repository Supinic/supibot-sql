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
		169,
		'gachisearch',
		'[\"gs\"]',
		'Searches for a given track in the gachi list, and attempts to post a link.',
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
		'(async function gachiSearch (context, ...args) {
	const query = args.join(\" \");
	if (!query) {
		return { reply: \"Pepega\" };
	}

	const params = new sb.URLParams();
	params.set(\"name\", query);
	params.set(\"includeTags\", \"6\");

	const data = JSON.parse(await sb.Utils.request(\"https://supinic.com/api/track/search?\" + params.toString())).data;
	
	if (!data || data.length === 0) {
		return {
			reply: \"No tracks matching that query have been found!\"
		};
	}

	const extra = (data.length > 1) 
		? ((data.length - 1) + \" more tracks found!\")
		: \"\";
	
	return {
		reply: data[0].name + \" - https://supinic.com/track/detail/\" + data[0].ID + \" \" + extra
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function gachiSearch (context, ...args) {
	const query = args.join(\" \");
	if (!query) {
		return { reply: \"Pepega\" };
	}

	const params = new sb.URLParams();
	params.set(\"name\", query);
	params.set(\"includeTags\", \"6\");

	const data = JSON.parse(await sb.Utils.request(\"https://supinic.com/api/track/search?\" + params.toString())).data;
	
	if (!data || data.length === 0) {
		return {
			reply: \"No tracks matching that query have been found!\"
		};
	}

	const extra = (data.length > 1) 
		? ((data.length - 1) + \" more tracks found!\")
		: \"\";
	
	return {
		reply: data[0].name + \" - https://supinic.com/track/detail/\" + data[0].ID + \" \" + extra
	};
})'