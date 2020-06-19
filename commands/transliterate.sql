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
		138,
		'transliterate',
		NULL,
		'ping,pipe',
		'Transliterates non-latin text into Latin. Should support most of the languages not using Latin (like Japanese, Chinese, Russian, ...)',
		15000,
		NULL,
		NULL,
		'(async function transliterate (context, ...args) {
	if (args.length === 0) {
		return {
			success: false,
			reply: \"No input provided!\"
		};
	}

	const html = await sb.Got({
		url: \"https://ichi.moe/cl/qr\",
		searchParams: new sb.URLParams()
			.set(\"r\", \"htr\")
			.set(\"q\", args.join(\" \"))
			.toString()
	}).text();

	const $ = sb.Utils.cheerio(html);
	const words = Array.from($(\"#div-ichiran-result span.ds-text:not(.hidden) span.ds-word\")).map(i => i.firstChild.data);
	if (words.length > 0) {
		return {
			reply: words.join(\" \")
		};
	}

	return {
		reply: sb.Utils.transliterate(args.join(\" \"))
	};
})',
		NULL,
		'supinic/supibot-sql'
	)