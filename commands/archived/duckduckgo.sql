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
		209,
		'duckduckgo',
		'[\"ddg\"]',
		'archived,mention,pipe',
		'Try the DuckDuckGo Instant Answer API to answer your questions!',
		15000,
		NULL,
		NULL,
		'(async function duckDuckGo (context, ...args) {
	const data = await sb.Got({
		url: \"https://api.duckduckgo.com/\",
		searchParams: new sb.URLParams()
			.set(\"format\", \"json\")
			.set(\"pretty\", \"1\")
			.set(\"q\", args.join(\" \"))
			.toString()
	}).json();

	const {
		Heading: heading,
		AbstractSource: source,
		AbstractURL: url,
		Abstract: abstract		
	} = data;

	if (!abstract) {
		return {
			reply: \"No data found!\"
		};
	}
	
	return {
		reply: sb.Utils.tag.trim `
			From ${source} -
			${heading}:
			${abstract}			
		`
	};	
})',
		NULL,
		'supinic/supibot-sql'
	)