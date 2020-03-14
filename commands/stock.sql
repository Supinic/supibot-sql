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
		107,
		'stock',
		NULL,
		'Fetches the latest price and daily change for a stock.',
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
		NULL,
		'(async function stock (context, symbol) {
	if (!symbol) {
		return { reply: \"A stock symbol must be provided!\" };
	}

	const { \"Global Quote\": data } = await sb.Got({
		retry: 0,
		throwHttpErrors: false,
		url: \"https://www.alphavantage.co/query\",
		searchParams: new sb.URLParams()
			.set(\"function\", \"GLOBAL_QUOTE\")
			.set(\"symbol\", symbol)
			.set(\"apikey\", sb.Config.get(\"API_ALPHA_AVANTAGE\"))
			.toString()
	}).json();

	if (!data) {
		return { 
			reply: \"Stock symbol could not be found!\"
		};
	}

	const identifier = (Number(data[\"10. change percent\"].replace(\"%\", \"\")) >= 0) ? \"+\" : \"\";
	return {
		reply: [
			\"Latest price for \" + data[\"01. symbol\"] + \":\",
			\"$\" + data[\"05. price\"] + \", \",
			\"change: \" + identifier + data[\"10. change percent\"]
		].join(\" \")
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function stock (context, symbol) {
	if (!symbol) {
		return { reply: \"A stock symbol must be provided!\" };
	}

	const { \"Global Quote\": data } = await sb.Got({
		retry: 0,
		throwHttpErrors: false,
		url: \"https://www.alphavantage.co/query\",
		searchParams: new sb.URLParams()
			.set(\"function\", \"GLOBAL_QUOTE\")
			.set(\"symbol\", symbol)
			.set(\"apikey\", sb.Config.get(\"API_ALPHA_AVANTAGE\"))
			.toString()
	}).json();

	if (!data) {
		return { 
			reply: \"Stock symbol could not be found!\"
		};
	}

	const identifier = (Number(data[\"10. change percent\"].replace(\"%\", \"\")) >= 0) ? \"+\" : \"\";
	return {
		reply: [
			\"Latest price for \" + data[\"01. symbol\"] + \":\",
			\"$\" + data[\"05. price\"] + \", \",
			\"change: \" + identifier + data[\"10. change percent\"]
		].join(\" \")
	};
})'