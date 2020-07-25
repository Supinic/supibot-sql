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
		134,
		'owoify',
		NULL,
		'archived,mention,pipe',
		'Turns the text you provide into a top tier shitpost.',
		10000,
		NULL,
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
		'supinic/supibot-sql'
	)