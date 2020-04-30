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
		24,
		'copypasta',
		NULL,
		NULL,
		'Fetches a random Twitch-related copypasta. The date of creation usually ranges from 2014-2015.',
		15000,
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
		0,
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
		'No arguments.',
		NULL
	)