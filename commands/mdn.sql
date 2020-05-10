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
		203,
		'mdn',
		NULL,
		'ping,pipe',
		'Searches the MDN website for a given term, then returns the article link.',
		10000,
		NULL,
		NULL,
		'(async function mdn (context, ...args) {
	const query = args.join(\" \");
	if (!query) {
		return {
			reply: \"No input provided!\"
		};
	}

	const data = await sb.Got({
		url: \"https://developer.mozilla.org/api/v1/search/en-US\",
		searchParams: new sb.URLParams()
			.set(\"q\", query)
			.toString()
	}).json();

	if (data.documents.length === 0) {
		return {
			reply: \"No articles found!\"
		};
	}

	const { title, slug } = data.documents[0];
	return {
		reply: `${title}: https://developer.mozilla.org/en-US/docs/${slug}`
	};
})',
		'async (prefix) => {
	const url = \"https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Operators/Nullish_coalescing_operator\";
	
	return [
		`<code>${prefix}mdn Nullish coalescing</code>`,
		`Nullish coalescing operator <a target=\"_blank\" href=\"${url}\">${url}</a>`
	];
}'
	)