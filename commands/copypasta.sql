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
		24,
		'copypasta',
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
		'async () => {
	const pastaRegex = /quote_display_content_0\">(.+?)<\\/span>/;
	const data = await sb.Utils.request(\"https://www.twitchquotes.com/random\");
	const copypasta = (data.match(pastaRegex) || [])[1];
	
	return {
		reply: (copypasta)
			? sb.Utils.removeHTML(copypasta).trim()
			: \"No copypasta found.\"
	};
}',
		'No arguments.',
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async () => {
	const pastaRegex = /quote_display_content_0\">(.+?)<\\/span>/;
	const data = await sb.Utils.request(\"https://www.twitchquotes.com/random\");
	const copypasta = (data.match(pastaRegex) || [])[1];
	
	return {
		reply: (copypasta)
			? sb.Utils.removeHTML(copypasta).trim()
			: \"No copypasta found.\"
	};
}'