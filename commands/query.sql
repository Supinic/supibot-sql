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
		'(async function query (context, ...args) {
	if (args.length === 0) {
		return { reply: \"No query provided!\", meta: { skipCooldown: true } };
	}

	const url = \"http://api.wolframalpha.com/v1/result?\";
	const query = new sb.URLParams()
		.set(\"appid\", sb.Config.get(\"API_WOLFRAM_ALPHA_APPID\"))
		.set(\"i\", args.join(\" \"));

	try {
		let data = await sb.Utils.request(url + query.toString());
		data = sb.Config.get(\"WOLFRAM_QUERY_CENSOR_FN\")(data);	

		if (data.toLowerCase().includes(\"<html>\")) {
			return { reply: \"Seems like the API is down eShrug\" };
		}
		
		return { reply: data };
	}
	catch (e) {
		if (e.statusCode === 501) {
			return { reply: e.error + \" FeelsBadMan\" };
		}

		console.error(e);
		return { reply: \"Probably ran out of WolframAlpha requests for this month.\" };
	}
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function query (context, ...args) {
	if (args.length === 0) {
		return { reply: \"No query provided!\", meta: { skipCooldown: true } };
	}

	const url = \"http://api.wolframalpha.com/v1/result?\";
	const query = new sb.URLParams()
		.set(\"appid\", sb.Config.get(\"API_WOLFRAM_ALPHA_APPID\"))
		.set(\"i\", args.join(\" \"));

	try {
		let data = await sb.Utils.request(url + query.toString());
		data = sb.Config.get(\"WOLFRAM_QUERY_CENSOR_FN\")(data);	

		if (data.toLowerCase().includes(\"<html>\")) {
			return { reply: \"Seems like the API is down eShrug\" };
		}
		
		return { reply: data };
	}
	catch (e) {
		if (e.statusCode === 501) {
			return { reply: e.error + \" FeelsBadMan\" };
		}

		console.error(e);
		return { reply: \"Probably ran out of WolframAlpha requests for this month.\" };
	}
})'