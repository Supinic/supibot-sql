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
		26,
		'currency',
		'[\"money\"]',
		'Attempts to convert a specified amount of one currency to another. Only supports 3-letter ISO codes. Example: 100 USD to EUR.',
		10000,
		0,
		0,
		1,
		0,
		NULL,
		0,
		0,
		0,
		1,
		1,
		0,
		'async (extra, amount, first, separator, second) => {
	if (!second) {
		second = separator;
		separator = first;
		first = amount;
		amount = \"1\";
	}

	if (!first || !second) {
		return { reply: \"Both currencies must be provided!\", meta: { skipCooldown: true } };
	}

	amount = amount.replace(/k/gi, \"0\".repeat(3)).replace(/m/gi, \"0\".repeat(6)).replace(/b/gi, \"0\".repeat(9));
	if (!Number(amount)) {
		return { reply: \"The amount must be a finite number!\", meta: { skipCooldown: true } };
	}

	const currencySymbol = first.toUpperCase() + \"_\" + second.toUpperCase();
	if (!(/[A-Z]{3}_[A-Z]{3}/.test(currencySymbol))) {
		return { reply: \"Both currencies must be represented by exactly 3 letters!\" };
	}

	const url = [
		\"https://free.currencyconverterapi.com/api/v6/convert\",
		\"?compact=ultra\",
		\"&q=\" + currencySymbol,
		\"&apiKey=\" + sb.Config.get(\"API_FREE_CURRENCY_CONVERTER\")
	].join(\"\");

	let rawData = null;
	let ratio = null;
	try {
		rawData = await sb.Utils.request(url);
		ratio = JSON.parse(rawData)[currencySymbol];
	}
	catch (e) {
		console.error(\"Currency convert error\", e, rawData);

		if (e.error) {
			return { 
				reply: \"API returned error: \" + sb.Utils.removeHTML(e.error).replace(/\\s+/g, \" \")
			};
		}
		else {
			return { reply: \"API site returned error: \" + sb.Utils.removeHTML(rawData).replace(/\\s+/g, \" \") };
		}
	}

	if (typeof ratio === \"number\") {
		return {
			reply: amount + \" \" + first + \" = \" + sb.Utils.round(amount * ratio, 3) + \" \" + second
		};
	}
	else {
		return { reply: \"One or both currencies were not recognized\" };
	}
}',
		'$currency <currency code> to <currency code> => Converts 1 of currency to the other
$currency <amount> <currency code> to <currency code> => Converts that amount of currency to the other

$currency USD to EUR
$currency 5000 SEK to AUD',
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async (extra, amount, first, separator, second) => {
	if (!second) {
		second = separator;
		separator = first;
		first = amount;
		amount = \"1\";
	}

	if (!first || !second) {
		return { reply: \"Both currencies must be provided!\", meta: { skipCooldown: true } };
	}

	amount = amount.replace(/k/gi, \"0\".repeat(3)).replace(/m/gi, \"0\".repeat(6)).replace(/b/gi, \"0\".repeat(9));
	if (!Number(amount)) {
		return { reply: \"The amount must be a finite number!\", meta: { skipCooldown: true } };
	}

	const currencySymbol = first.toUpperCase() + \"_\" + second.toUpperCase();
	if (!(/[A-Z]{3}_[A-Z]{3}/.test(currencySymbol))) {
		return { reply: \"Both currencies must be represented by exactly 3 letters!\" };
	}

	const url = [
		\"https://free.currencyconverterapi.com/api/v6/convert\",
		\"?compact=ultra\",
		\"&q=\" + currencySymbol,
		\"&apiKey=\" + sb.Config.get(\"API_FREE_CURRENCY_CONVERTER\")
	].join(\"\");

	let rawData = null;
	let ratio = null;
	try {
		rawData = await sb.Utils.request(url);
		ratio = JSON.parse(rawData)[currencySymbol];
	}
	catch (e) {
		console.error(\"Currency convert error\", e, rawData);

		if (e.error) {
			return { 
				reply: \"API returned error: \" + sb.Utils.removeHTML(e.error).replace(/\\s+/g, \" \")
			};
		}
		else {
			return { reply: \"API site returned error: \" + sb.Utils.removeHTML(rawData).replace(/\\s+/g, \" \") };
		}
	}

	if (typeof ratio === \"number\") {
		return {
			reply: amount + \" \" + first + \" = \" + sb.Utils.round(amount * ratio, 3) + \" \" + second
		};
	}
	else {
		return { reply: \"One or both currencies were not recognized\" };
	}
}'