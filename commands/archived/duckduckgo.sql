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
		209,
		'duckduckgo',
		'[\"ddg\"]',
		NULL,
		'Try the DuckDuckGo Instant Answer API to answer your questions!',
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
		1,
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
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function duckDuckGo (context, ...args) {
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
})'