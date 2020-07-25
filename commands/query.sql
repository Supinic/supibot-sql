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
		115,
		'query',
		NULL,
		'mention,pipe',
		'Wolfram Alpha query',
		60000,
		NULL,
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
		'supinic/supibot-sql'
	)