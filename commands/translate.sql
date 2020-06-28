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
		38,
		'translate',
		NULL,
		'ping,pipe',
		'Implicitly translates from auto-recognized language to English. Supports parameters \'from\' and \'to\'. Example: from:german to:french Guten Tag\",',
		15000,
		NULL,
		NULL,
		'(async function translate (context, ...args) {
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
	else if (args.length === 0) {
		return {
			reply: \"No text for translation provided!\",
			cooldown: 2500
		};
	}

	const response = await sb.Got({
		url: \"https://translate.googleapis.com/translate_a/single\",
		throwHttpErrors: false,
		searchParams: new sb.URLParams()
			.set(\"client\", \"gtx\")
			.set(\"dt\", \"t\")
			.set(\"sl\", options.from)
			.set(\"tl\", options.to)
			.set(\"ie\", \"UTF-8\")
			.set(\"oe\", \"UTF-8\")
			.set(\"q\", args.join(\" \"))
			.toString()
	}).json();

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
		'supinic/supibot-sql'
	)