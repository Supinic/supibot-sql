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
		38,
		'translate',
		NULL,
		'Implicitly translates from auto-recognized language to English. Supports parameters \'from\' and \'to\'. Example: from:german to:french Guten Tag\",',
		8000,
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
		'(async function translate (context, ...args) {
	if (args.length === 0) {
		return {
			reply: \"No text for translation provided!\",
			meta: { skipCooldown: true }
		};
	}

	const options = { from: \"auto\", to: \"en\", direction: true, confidence: true };
	let fail = { from: null, to: null };

	for (let i = args.length - 1; i >= 0; i--) {
		const token = args[i];
		if (/^(from|to):/.test(token)) {
			const [option, lang] = args[i].split(\":\");
			const newLang = sb.Utils.languageISO.getCode(lang);

			if (!newLang) {
				fail[option] = lang;
				continue;
			}

			options[option] = newLang.toLowerCase();
			fail[option] = false;
			args.splice(i, 1);
		}
		else if (token === \"direction:false\") {
			options.direction = false;
			args.splice(i, 1);
		}
		else if (token === \"confidence:false\") {
			options.confidence = false;
			args.splice(i, 1);
		}
	}

	if (fail.from || fail.to) {
		return { reply: `Language \"${fail.from || fail.to}\" was not recognized!` };
	}

	const url = \"https://translate.googleapis.com/translate_a/single?\";
	const params = new sb.URLParams()
		.set(\"client\", \"gtx\")
		.set(\"dt\", \"t\")
		.set(\"sl\", options.from)
		.set(\"tl\", options.to)
		.set(\"ie\", \"UTF-8\")
		.set(\"oe\", \"UTF-8\")
		.set(\"q\", args.join(\" \"));

	let response = null;
	try {
		response = JSON.parse(await sb.Utils.request(url + params.toString()));
	}
	catch (e) {
		console.warn(e);
		return { reply: e.statusCode + \" \" + e.name };
	}

	let reply = response[0].map(i => i[0]).join(\" \");
	if (options.direction) {
		let array = [sb.Utils.capitalize(sb.Utils.languageISO.getName(response[2]))];

		if (options.confidence && response[6] && response[6] !== 1) {
			const confidence = sb.Utils.round(response[6] * 100, 0) + \"%\";
			array.push(\"(\" +  confidence + \")\");
		}

		array.push(\"->\", sb.Utils.capitalize(sb.Utils.languageISO.getName(options.to)));
		reply = array.join(\" \") + \": \" + reply;
	}

	return { reply: reply };
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function translate (context, ...args) {
	if (args.length === 0) {
		return {
			reply: \"No text for translation provided!\",
			meta: { skipCooldown: true }
		};
	}

	const options = { from: \"auto\", to: \"en\", direction: true, confidence: true };
	let fail = { from: null, to: null };

	for (let i = args.length - 1; i >= 0; i--) {
		const token = args[i];
		if (/^(from|to):/.test(token)) {
			const [option, lang] = args[i].split(\":\");
			const newLang = sb.Utils.languageISO.getCode(lang);

			if (!newLang) {
				fail[option] = lang;
				continue;
			}

			options[option] = newLang.toLowerCase();
			fail[option] = false;
			args.splice(i, 1);
		}
		else if (token === \"direction:false\") {
			options.direction = false;
			args.splice(i, 1);
		}
		else if (token === \"confidence:false\") {
			options.confidence = false;
			args.splice(i, 1);
		}
	}

	if (fail.from || fail.to) {
		return { reply: `Language \"${fail.from || fail.to}\" was not recognized!` };
	}

	const url = \"https://translate.googleapis.com/translate_a/single?\";
	const params = new sb.URLParams()
		.set(\"client\", \"gtx\")
		.set(\"dt\", \"t\")
		.set(\"sl\", options.from)
		.set(\"tl\", options.to)
		.set(\"ie\", \"UTF-8\")
		.set(\"oe\", \"UTF-8\")
		.set(\"q\", args.join(\" \"));

	let response = null;
	try {
		response = JSON.parse(await sb.Utils.request(url + params.toString()));
	}
	catch (e) {
		console.warn(e);
		return { reply: e.statusCode + \" \" + e.name };
	}

	let reply = response[0].map(i => i[0]).join(\" \");
	if (options.direction) {
		let array = [sb.Utils.capitalize(sb.Utils.languageISO.getName(response[2]))];

		if (options.confidence && response[6] && response[6] !== 1) {
			const confidence = sb.Utils.round(response[6] * 100, 0) + \"%\";
			array.push(\"(\" +  confidence + \")\");
		}

		array.push(\"->\", sb.Utils.capitalize(sb.Utils.languageISO.getName(options.to)));
		reply = array.join(\" \") + \": \" + reply;
	}

	return { reply: reply };
})'