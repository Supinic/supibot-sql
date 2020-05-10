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
		24,
		'copypasta',
		NULL,
		'ping,pipe',
		'Fetches a random Twitch-related copypasta. The date of creation usually ranges from 2014-2015.',
		15000,
		NULL,
		NULL,
		'(async function copypasta () {
	const html = await sb.Got(\"https://www.twitchquotes.com/random\").text();
	const $ = sb.Utils.cheerio(html);
	const copypasta = $(\"#quote_display_content_0\").text();

	return {
		reply: (copypasta)
			? sb.Utils.removeHTML(copypasta).trim()
			: \"No copypasta found.\"
	};
})',
		NULL
	)