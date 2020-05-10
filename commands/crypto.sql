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
		Dynamic_Description
	)
VALUES
	(
		84,
		'crypto',
		NULL,
		'ping,pipe',
		'Fetches the latest price of a cryptocurrency.',
		10000,
		NULL,
		NULL,
		'(async function crypto (context, symbol = \"BTC\") {
	symbol = symbol.toUpperCase();

	const data = await sb.Got({
		url: \"https://min-api.cryptocompare.com/data/price\",
		searchParams: new sb.URLParams().set(\"fsym\", symbol).set(\"tsyms\", \"USD,EUR\").toString(),
		headers: {
			Authorization: \"Apikey \" + sb.Config.get(\"API_CRYPTO_COMPARE\")
		}
	}).json();

	if (data.Response === \"Error\") {
		return {
			reply: data.Message
		};
	}
	else {
		return {
			reply: `Current price of ${symbol}: $${data.USD}, €${data.EUR}`
		};
	}
})',
		NULL
	)