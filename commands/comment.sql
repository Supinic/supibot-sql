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
		7,
		'comment',
		NULL,
		'ping,pipe',
		'Fetches a random comment from a set of 10 thousand randomly generated Youtube videos.',
		15000,
		NULL,
		NULL,
		'(async function comment () {
	const html = await sb.Got(\"http://www.randomyoutubecomment.com\").text();
	const $ = sb.Utils.cheerio(html);
	const comment = $(\"#comment\").text();

	return {
		reply: comment ?? \"No comment was available to fetch\"
	};
})',
		NULL,
		'supinic/supibot-sql'
	)