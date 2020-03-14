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
		Static_Data,
		Code,
		Examples,
		Dynamic_Description
	)
VALUES
	(
		7,
		'comment',
		NULL,
		'Fetches a random comment from a set of 10 thousand randomly generated Youtube videos.',
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
		NULL,
		'(async function comment () {
	const html = await sb.Got(\"http://www.randomyoutubecomment.com\").text();
	const $ = sb.Utils.cheerio(html);
	const comment = $(\"#comment\").text();

	return {
		reply: comment ?? \"No comment was available to fetch\"
	};
})',
		'No arguments.

$comment',
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function comment () {
	const html = await sb.Got(\"http://www.randomyoutubecomment.com\").text();
	const $ = sb.Utils.cheerio(html);
	const comment = $(\"#comment\").text();

	return {
		reply: comment ?? \"No comment was available to fetch\"
	};
})'