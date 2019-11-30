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
		'async (extra, symbol) => {
	if (!symbol) {
		return { reply: \"A symbol must be provided!\" };
	}
	
	const params = new sb.URLParams()
		.set(\"function\", \"GLOBAL_QUOTE\")
		.set(\"symbol\", symbol)
		.set(\"apikey\", sb.Config.get(\"API_ALPHA_AVANTAGE\"));
	
	const url = `https://www.alphavantage.co/query?${params.toString()}`;
	try {
		const data = (JSON.parse(await sb.Utils.request(url)))[\"Global Quote\"];
		const symbol = (Number(data[\"10. change percent\"].replace(\"%\", \"\")) >= 0) ? \"+\" : \"\";
		return { 
			reply: [
				\"Latest price for \" + data[\"01. symbol\"] + \":\",
				\"$\" + data[\"05. price\"] + \", \",
				\"change: \" + symbol + data[\"10. change percent\"]
			].join(\" \")
		};
	}	
	catch (e) {
		console.error(e);
		return { reply: \"Well, shit\" };
	}
}',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async (extra, symbol) => {
	if (!symbol) {
		return { reply: \"A symbol must be provided!\" };
	}
	
	const params = new sb.URLParams()
		.set(\"function\", \"GLOBAL_QUOTE\")
		.set(\"symbol\", symbol)
		.set(\"apikey\", sb.Config.get(\"API_ALPHA_AVANTAGE\"));
	
	const url = `https://www.alphavantage.co/query?${params.toString()}`;
	try {
		const data = (JSON.parse(await sb.Utils.request(url)))[\"Global Quote\"];
		const symbol = (Number(data[\"10. change percent\"].replace(\"%\", \"\")) >= 0) ? \"+\" : \"\";
		return { 
			reply: [
				\"Latest price for \" + data[\"01. symbol\"] + \":\",
				\"$\" + data[\"05. price\"] + \", \",
				\"change: \" + symbol + data[\"10. change percent\"]
			].join(\" \")
		};
	}	
	catch (e) {
		console.error(e);
		return { reply: \"Well, shit\" };
	}
}'