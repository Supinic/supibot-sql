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
		131,
		'KKona',
		'[\"KKrikey\", \"KKonaW\", \"kkOna\", \"3Head\"]',
		'\"Translates\" your given text into late 19th - early 20th century cowboy lingo.',
		10000,
		0,
		1,
		0,
		0,
		NULL,
		0,
		0,
		0,
		0,
		1,
		1,
		'async (extra, ...args) => {
	const input = args.join(\" \");
	if (!input) {
		return { reply: \"No phrase provided!\" };
	}
 
	const check = extra.invocation.toLowerCase();
	const data = (check.includes(\"kkona\"))
		? sb.Config.get(\"TRANSLATION_DATA_COWBOY\")
		: (check.includes(\"3head\"))
			? sb.Config.get(\"TRANSLATION_DATA_COCKNEY\")
			: sb.Config.get(\"TRANSLATION_DATA_STRAYA\");
		
	let output = input;
	for (const [from, to] of data.phrasesWords) {
		const r = new RegExp(\"\\\\b\" + from + \"\\\\b\", \"gi\");
		output = output.replace(r, \"_\" + to + \"_\");
	}
 
	for (const [from, to] of data.prefixes) {
		const r = new RegExp(\"\\\\b\" + from, \"gi\");
		output = output.replace(r, to);
	}
 
	for (const [from, to] of data.suffixes) {
		const r = new RegExp(from + \"\\\\b\", \"gi\");
		output = output.replace(r, to);
	}

	for (const [from, to] of data.intrawords) {
		const r = new RegExp(from, \"gi\");
		output = output.replace(r, to);
	}

	output = output.trim();

	if (data.endings && /[\\)\\.\\?\\!]$/.test(output)) {
		output += \" \" + sb.Utils.randArray(data.endings);
	}
	   
	return { reply: extra.invocation + \" \" + output.replace(/_/g, \"\") };
}',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async (extra, ...args) => {
	const input = args.join(\" \");
	if (!input) {
		return { reply: \"No phrase provided!\" };
	}
 
	const check = extra.invocation.toLowerCase();
	const data = (check.includes(\"kkona\"))
		? sb.Config.get(\"TRANSLATION_DATA_COWBOY\")
		: (check.includes(\"3head\"))
			? sb.Config.get(\"TRANSLATION_DATA_COCKNEY\")
			: sb.Config.get(\"TRANSLATION_DATA_STRAYA\");
		
	let output = input;
	for (const [from, to] of data.phrasesWords) {
		const r = new RegExp(\"\\\\b\" + from + \"\\\\b\", \"gi\");
		output = output.replace(r, \"_\" + to + \"_\");
	}
 
	for (const [from, to] of data.prefixes) {
		const r = new RegExp(\"\\\\b\" + from, \"gi\");
		output = output.replace(r, to);
	}
 
	for (const [from, to] of data.suffixes) {
		const r = new RegExp(from + \"\\\\b\", \"gi\");
		output = output.replace(r, to);
	}

	for (const [from, to] of data.intrawords) {
		const r = new RegExp(from, \"gi\");
		output = output.replace(r, to);
	}

	output = output.trim();

	if (data.endings && /[\\)\\.\\?\\!]$/.test(output)) {
		output += \" \" + sb.Utils.randArray(data.endings);
	}
	   
	return { reply: extra.invocation + \" \" + output.replace(/_/g, \"\") };
}'