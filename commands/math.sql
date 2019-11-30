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
		3,
		'math',
		NULL,
		'Does math. For more info, check the documentation for math.js',
		5000,
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
		'async (extra, ...expression) => {
	const url = \"https://api.ivr.fi/math/?\";
	const params = new sb.URLParams().set(\"expr\", expression.join(\" \"));

	let result = null;
	try {
		result = JSON.parse(await sb.Utils.request(url + String(params), {
			headers: {
				\"User-Agent\": sb.Config.get(\"SUPIBOT_USER_AGENT\")
			}
		}));
	}
	catch (e) {
		const data = JSON.parse(e.response.body);
		result = {
			status: data.status,
			response: data.response
		};
	}

	return {
		reply: (result.status === 200 || result.status === 503) 
			? result.response.replace(/\\bNaN\\b/g, \"NaM\").replace(/\\btrue\\b/g, \"TRUE LULW\")
			: \"Oh shit @Leppunen pajaS\"
	};
/*
	return;
	try {
		let result = await sb.MathWorker.evaluate(expression.join(\" \"));
		if (result === \"true\") {
			result = \"TRUE LULW\";
		}

		return {
			reply: result
		};
	}
	catch (e) {
		if (e.name === \"TimeoutError\") {
			return {
				 reply: \"Math evaluation timed out (\" + (sb.Config.get(\"MATH_TIMEOUT\") / 1000) + \" seconds)\"
			};
		}
		else {
			return { reply: e.toString() };
		}
	}
*/
}',
		NULL,
		'async (prefix) => {
	return [
		\"Calculates advanced maths. You can use functions, derivatives, integrals, methods, ...\",
		\"Look here for more info: <a href=\'https://mathjs.org/\'>mathjs documentation</a>\",
		\"Arguments are the mathematical expression you want to calculate.\",
		\"\",
		prefix + \"math e^(i*pi) + 1 => 0\",
		prefix + \"math 1+1 => 2\",
		prefix + \"math sin(pi/2) => 1\" 
	];
}'
	)

ON DUPLICATE KEY UPDATE
	Code = 'async (extra, ...expression) => {
	const url = \"https://api.ivr.fi/math/?\";
	const params = new sb.URLParams().set(\"expr\", expression.join(\" \"));

	let result = null;
	try {
		result = JSON.parse(await sb.Utils.request(url + String(params), {
			headers: {
				\"User-Agent\": sb.Config.get(\"SUPIBOT_USER_AGENT\")
			}
		}));
	}
	catch (e) {
		const data = JSON.parse(e.response.body);
		result = {
			status: data.status,
			response: data.response
		};
	}

	return {
		reply: (result.status === 200 || result.status === 503) 
			? result.response.replace(/\\bNaN\\b/g, \"NaM\").replace(/\\btrue\\b/g, \"TRUE LULW\")
			: \"Oh shit @Leppunen pajaS\"
	};
/*
	return;
	try {
		let result = await sb.MathWorker.evaluate(expression.join(\" \"));
		if (result === \"true\") {
			result = \"TRUE LULW\";
		}

		return {
			reply: result
		};
	}
	catch (e) {
		if (e.name === \"TimeoutError\") {
			return {
				 reply: \"Math evaluation timed out (\" + (sb.Config.get(\"MATH_TIMEOUT\") / 1000) + \" seconds)\"
			};
		}
		else {
			return { reply: e.toString() };
		}
	}
*/
}'