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
		115,
		'query',
		NULL,
		'Wolfram Alpha query',
		60000,
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
		'(async function query (context, ...args) {
	if (args.length === 0) {
		return {
			reply: \"No query provided!\",
			cooldown: { length: 2500 }
		};
	}

	const rawData = await sb.Got({
		throwHttpErrors: false,
		url: \"http://api.wolframalpha.com/v1/result\",
		searchParams: new sb.URLParams()
			.set(\"appid\", sb.Config.get(\"API_WOLFRAM_ALPHA_APPID\"))
			.set(\"i\", args.join(\" \"))
			.toString()
	}).text();

	const data = sb.Config.get(\"WOLFRAM_QUERY_CENSOR_FN\")(rawData);
	return { 
		reply: (context.platform.Name === \"discord\")
			? `\\`${data}\\``
			: data
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function query (context, ...args) {
	if (args.length === 0) {
		return {
			reply: \"No query provided!\",
			cooldown: { length: 2500 }
		};
	}

	const rawData = await sb.Got({
		throwHttpErrors: false,
		url: \"http://api.wolframalpha.com/v1/result\",
		searchParams: new sb.URLParams()
			.set(\"appid\", sb.Config.get(\"API_WOLFRAM_ALPHA_APPID\"))
			.set(\"i\", args.join(\" \"))
			.toString()
	}).text();

	const data = sb.Config.get(\"WOLFRAM_QUERY_CENSOR_FN\")(rawData);
	return { 
		reply: (context.platform.Name === \"discord\")
			? `\\`${data}\\``
			: data
	};
})'