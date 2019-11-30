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
		84,
		'crypto',
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
		'async (extra, symbol = \"BTC\") => {
	symbol = symbol.toUpperCase();

	const apiKey = sb.Config.get(\"API_CRYPTO_COMPARE\");
	const url = `https://min-api.cryptocompare.com/data/price?fsym=${symbol}&tsyms=USD,EUR`;

	const data = JSON.parse(await sb.Utils.request({
		url: url,
		headers: {
			Authorization: \"Apikey \" + sb.Config.get(\"API_CRYPTO_COMPARE\")
		}
	}));
	
	if (data.Response === \"Error\") {
		return { reply: data.Message };
	}
	else {
		return { reply: \"Current price of \" + symbol + \": $\" + data.USD + \", €\" + data.EUR };
	}
}',
		'$crypto => Posts Bitcoin\'s current price.
$crypto <cryptocurrency code> => Posts that currency\' current price.

$crypto DOGE',
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async (extra, symbol = \"BTC\") => {
	symbol = symbol.toUpperCase();

	const apiKey = sb.Config.get(\"API_CRYPTO_COMPARE\");
	const url = `https://min-api.cryptocompare.com/data/price?fsym=${symbol}&tsyms=USD,EUR`;

	const data = JSON.parse(await sb.Utils.request({
		url: url,
		headers: {
			Authorization: \"Apikey \" + sb.Config.get(\"API_CRYPTO_COMPARE\")
		}
	}));
	
	if (data.Response === \"Error\") {
		return { reply: data.Message };
	}
	else {
		return { reply: \"Current price of \" + symbol + \": $\" + data.USD + \", €\" + data.EUR };
	}
}'