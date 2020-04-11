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
		84,
		'crypto',
		NULL,
		NULL,
		'Fetches the latest price of a cryptocurrency.',
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
		'$crypto => Posts Bitcoin\'s current price.
$crypto <cryptocurrency code> => Posts that currency\' current price.

$crypto DOGE',
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function crypto (context, symbol = \"BTC\") {
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
})'