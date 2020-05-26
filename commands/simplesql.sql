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
		125,
		'simplesql',
		'[\"ssql\"]',
		'ping,pipe,system,whitelist',
		'Executes a quick SQL query, and returns its (simple) result.',
		0,
		NULL,
		NULL,
		'(async function simpleSQL (context, ...args) {
	let query = args.join(\" \");
	try {
		if (!query.includes(\"AVG\") && !query.includes(\"LIMIT 1\")) {
			query += \" LIMIT 1\";
		}

		const result = await sb.Query.raw(query);
		return { reply: String(result[0][Object.keys(result[0])[0]]) };
	}
	catch (e) {
		console.warn(e);
		return { reply: \"An error occured!\" };
	}
})',
		NULL,
		'supinic/supibot-sql'
	)