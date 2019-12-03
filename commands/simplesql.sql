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
		125,
		'simplesql',
		'[\"ssql\"]',
		'Executes a quick SQL query, and returns its (simple) result.',
		0,
		0,
		1,
		0,
		1,
		NULL,
		0,
		0,
		0,
		1,
		1,
		0,
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
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function simpleSQL (context, ...args) {
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
})'