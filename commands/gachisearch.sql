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
		169,
		'gachisearch',
		'[\"gs\"]',
		'mention,pipe',
		'Searches for a given track in the gachi list, and attempts to post a link.',
		15000,
		NULL,
		NULL,
		'(async function gachiSearch (context, ...args) {
	const query = args.join(\" \");
	if (!query) {
		return { 
			success: false,
			reply: \"No search query provided!\"
		};
	}

	const searchParams = new sb.URLParams()
		.set(\"name\", query)
		.set(\"includeTags\", \"6\")
		.toString();

	const { data } = await sb.Got.instances.Supinic({
		url: \"track/search\",
		searchParams
	}).json();

	if (!data || data.length === 0) {
		return {
			success: false,
			reply: \"No tracks matching that query have been found!\"
		};
	}

	const extra = (data.length > 1)
		? `${data.length - 1} more tracks found! JSON: https://supinic.com/api/track/search?${searchParams}`
		: \"\";

	return {
		reply: `${data[0].name} - https://supinic.com/track/detail/${data[0].ID} ${extra}`
	};
})',
		NULL,
		'supinic/supibot-sql'
	)