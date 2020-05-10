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
		Dynamic_Description
	)
VALUES
	(
		80,
		'randomword',
		'[\"rw\"]',
		'pipe',
		'Fetches a random word. If a number is provided, rolls that many words.',
		5000,
		NULL,
		'({
	limit: 10
})',
		'(async function randomWord (context, number = 1) {
	const repeats = Number(number);
	if (!repeats || repeats > this.staticData.limit || repeats < 1 || Math.trunc(repeats) !== repeats) {
		return { reply: \"Invalid or too high amount of words!\" };
	}

	return {
		reply: [...Array(repeats)].map(() => sb.Utils.randArray(sb.Config.get(\"WORD_LIST\"))).join(\" \")
	};
})',
		'async (prefix, values) => {
	const { limit } = values.getStaticData();
	const list = sb.Config.get(\"WORD_LIST\");

	return [
		\"Returns a random word from a list of \" + list.length + \" pre-determined words.\",
		\"Highly recommended for its usage in pipe, for example into urban or translate...\",
		`Maximum amount of words: ${limit}`,
		\"\",
		
		`<code>${prefix}rw</code>`,	
		\"(one random word)\",
		\"\",

		`<code>${prefix}rw 10</code>`,	
		\"(ten random words)\",
		\"\",

		\"Word list: <br>\" + list.join(\"<br>\")
	];
}'
	)