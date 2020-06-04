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
		26,
		'currency',
		'[\"money\"]',
		'ping,pipe,skip-banphrase',
		'Attempts to convert a specified amount of one currency to another. Only supports 3-letter ISO codes. Example: 100 USD to EUR.',
		10000,
		NULL,
		NULL,
		'(async function currency (context, amount, first, separator, second)  {
	if (!second && !separator) {
		second = first;
		first = amount;
		amount = \"1\";
	}
	if (!second) {
		second = separator;
		first = amount;
		amount = \"1\";
	}

	if (!first || !second) {
		return {
			success: false,
			reply: \"Invalid syntax! Use (amount) (from-currency) to (to-currency) - e.g. 1 USD to EUR\",
			cooldown: 2500
		};
	}

	let multiplier = 1;
	if (/k/i.test(amount)) {
		multiplier = 1.0e3;
	}
	else if (/m/i.test(amount)) {
		multiplier = 1.0e6;
	}
	else if (/b/i.test(amount)) {
		multiplier = 1.0e9;
	}
	else if (/t/i.test(amount)) {
		multiplier = 1.0e12;
	}

	amount = amount.replace(/[kmbt]/gi, \"\").replace(/,/g, \".\");
	if (!Number(amount)) {
		return {
			success: false,
			reply: \"The amount of currency must be a proper finite number!\",
			cooldown: {
				length: 2500
			}
		};
	}

	const currencySymbol = first.toUpperCase() + \"_\" + second.toUpperCase();
	if (!(/[A-Z]{3}_[A-Z]{3}/.test(currencySymbol))) {
		return {
			success: false,
			reply: \"Invalid syntax! Use (amount) (from-currency) to (to-currency) - e.g. 1 USD to EUR\",
			cooldown: 2500
		};
	}

	if (!this.data.cache) {
		this.data.cache = {};
	}

	if (!this.data.cache[currencySymbol] || sb.Date.now() > this.data.cache[currencySymbol].expiry) {
		const { statusCode, body: data } = await sb.Got({
			prefixUrl: \"https://free.currencyconverterapi.com/api\",
			url: \"v6/convert\",
			retry: 0,
			throwHttpErrors: false,
			responseType: \"json\",
			searchParams: new sb.URLParams()
				.set(\"compact\", \"ultra\")
				.set(\"q\", currencySymbol)
				.set(\"apiKey\", sb.Config.get(\"API_FREE_CURRENCY_CONVERTER\"))
				.toString()
		});

		if (statusCode !== 200) {
			throw new sb.errors.APIError({
				statusCode,
				apiName: \"CurrencyConverterAPI\"
			});
		}

		if (typeof data[currencySymbol] === \"number\") {
			this.data.cache[currencySymbol] = {
				ratio: data[currencySymbol],
				expiry: new sb.Date().addDays(1).valueOf()
			};
		}
		else {
			this.data.cache[currencySymbol] = {
				ratio: null,
				expiry: Infinity
			};
		}
	}

	const { ratio } = this.data.cache[currencySymbol];
	if (typeof ratio === \"number\") {
		return {
			reply: `${amount * multiplier} ${first} = ${sb.Utils.round(amount * multiplier * ratio, 3)} ${second}`
		};
	}
	else {
		return {
			reply: \"One or both currencies were not recognized!\"
		};
	}
})',
		'async (prefix) =>  [
	`Converts an amount of currency (or 1, if not specified) to another currency`,
	``,

	`<code>${prefix}currency 100 EUR to USD</code>`,
	`100 EUR = (amount) USD`,
	``,

	`<code>${prefix}currency EUR to VND</code>`,
	`1 EUR = (amount) VND`
];',
		'supinic/supibot-sql'
	)
