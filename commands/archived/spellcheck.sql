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
		182,
		'spellcheck',
		'[\"sc\"]',
		'archived,mention,pipe',
		'Spell checks your message.',
		25000,
		NULL,
		NULL,
		'(async function spellCheck (context, ...args) {
	if (args.length === 0) {
		return {
			reply: \"No message provided!\"
		};
	}

	let language = \"auto\";
	for (let i = 0; i < args.length; i++) {
		const token = args[i];
		if (/from:\\w+/.test(token)) {
			language = token.match(/from:(\\w+)/)[1];
			args.splice(i, 1);
		}
	}

	let message = args.join(\" \");
	const url = \"https://languagetool.org/api/v2/check?\";
	const params = new sb.URLParams()
		.set(\"language\", language)
		.set(\"disabledRules\", \"UPPERCASE_SENTENCE_START,NO_PERIOD,BRAK_KROPKI\")
		.set(\"text\", message);

	const rawData = await sb.Utils.request({
		url: url + params.toString(),
		method: \"GET\"
	});

	const data = JSON.parse(rawData);
	console.log(data);
	
	for (let i = data.matches.length - 1; i >= 0; i--) {
		const { offset, length, replacements } = data.matches[i];
		message = message.slice(0, offset) + replacements[0].value + message.slice(offset + length);
	}

	return {
		reply: message
	};
})',
		NULL,
		'supinic/supibot-sql'
	)