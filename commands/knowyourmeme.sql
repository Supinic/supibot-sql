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
		188,
		'knowyourmeme',
		'[\"kym\"]',
		'ping,pipe',
		'Gets a smol description of a meme from KnowYourMeme, it\'s just the summary.',
		30000,
		NULL,
		NULL,
		'(async function knowYourMeme (context, ...args) {
	if (args.length === 0) {
		return {
			reply: \"No search term provided!\"
		};
	}

	const searchHTML = await sb.Got.instances.FakeAgent({
		url: \"https://knowyourmeme.com/search\",
		searchParams: new sb.URLParams().set(\"q\", args.join(\" \")).toString()
	}).text();

	const $search = sb.Utils.cheerio(searchHTML);	
	const firstLink = $search(\".entry_list a\").first().attr(\"href\");
	if (!firstLink) {
		return {
			reply: \"No result found for given search term!\"
		};
	}
	
	const detailHTML = await sb.Got.instances.FakeAgent({
		prefixUrl: \"https://knowyourmeme.com\",
		url: firstLink,
	}).text();

	const $detail = sb.Utils.cheerio(detailHTML);
	const summary = $detail(\"#entry_body h2#about\").first().next().text();
	if (!summary) {
		return {
			reply: \"No summary found for given meme!\"
		};
	}

	return {
		reply: summary
	};
})',
		NULL,
		'supinic/supibot-sql'
	)