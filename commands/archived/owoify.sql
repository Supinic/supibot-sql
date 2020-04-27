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
		134,
		'owoify',
		NULL,
		NULL,
		'Turns the text you provide into a top tier shitpost.',
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
		1,
		NULL,
		'async (extra, ...args) => {
	return {
		reply: \"Command archived. Use $texttransform owo (or $tt owo for short) instead\"
	};

	const phrase = args.join(\" \");
	if (!phrase) {
		return { reply: \"No text provided!\" };
	}

	const faces = [\"(・`ω´・)\", \";;w;;\", \"owo\", \"UwU\", \">w<\", \"^w^\"];
	const output = phrase.replace(/(?:r|l)/g, \"w\")
		.replace(/(?:R|L)/g, \"W\")
		.replace(/n([aeiou])/g, \"ny$1\")
		.replace(/N([aeiou])/g, \"Ny$1\")
		.replace(/N([AEIOU])/g, \"Ny$1\")
		.replace(/ove/g, \"uv\")
		.replace(/\\!+/g, \" \" + sb.Utils.randArray(faces) + \" \");

	return { reply: output };
}',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async (extra, ...args) => {
	return {
		reply: \"Command archived. Use $texttransform owo (or $tt owo for short) instead\"
	};

	const phrase = args.join(\" \");
	if (!phrase) {
		return { reply: \"No text provided!\" };
	}

	const faces = [\"(・`ω´・)\", \";;w;;\", \"owo\", \"UwU\", \">w<\", \"^w^\"];
	const output = phrase.replace(/(?:r|l)/g, \"w\")
		.replace(/(?:R|L)/g, \"W\")
		.replace(/n([aeiou])/g, \"ny$1\")
		.replace(/N([aeiou])/g, \"Ny$1\")
		.replace(/N([AEIOU])/g, \"Ny$1\")
		.replace(/ove/g, \"uv\")
		.replace(/\\!+/g, \" \" + sb.Utils.randArray(faces) + \" \");

	return { reply: output };
}'