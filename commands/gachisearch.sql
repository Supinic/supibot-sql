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
		NULL,
		'(async function gachiSearch (context, ...args) {
	const query = args.join(\" \");
	if (!query) {
		return { reply: \"Pepega\" };
	}

	const { data } = await sb.Got.instances.Supinic({
		url: \"track/search\",
		searchParams: new sb.URLParams()
			.set(\"name\", query)
			.set(\"includeTags\", \"6\")
			.toString()
	}).json();
	
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

	const { data } = await sb.Got.instances.Supinic({
		url: \"track/search\",
		searchParams: new sb.URLParams()
			.set(\"name\", query)
			.set(\"includeTags\", \"6\")
			.toString()
	}).json();
	
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