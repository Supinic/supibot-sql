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
		186,
		'thesaurus',
		NULL,
		'Attempts to re-created your sentence using random synonyms for each word. EXPERIMENTAL',
		30000,
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
		'(async function thesaurus (context, ...words) {
	if (words.length === 0) {
		return {
			reply: \"No message provided!\"
		};
	}

	const thesaurus = Object.fromEntries(
		(await sb.Query.getRecordset(rs => rs
			.select(\"Word\", \"Result\")
			.from(\"cache\", \"Thesaurus\")
			.where(\"Word IN %s+\", words)
		)).map(record => [ record.Word, JSON.parse(record.Result) ])
	);

	const result = [];
	for (const rawWord of words) {
		const word = rawWord.toLowerCase();
		const roll = sb.Utils.random(1, 3);

		// With a chance of 2 in 3, transmute the word into a synonym
		if (thesaurus[word] && roll > 1) {
			result.push(sb.Utils.randArray(thesaurus[word]));
		}
		else {
			result.push(rawWord);
		}
	}

	return {
		reply: result.join(\" \")
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function thesaurus (context, ...words) {
	if (words.length === 0) {
		return {
			reply: \"No message provided!\"
		};
	}

	const thesaurus = Object.fromEntries(
		(await sb.Query.getRecordset(rs => rs
			.select(\"Word\", \"Result\")
			.from(\"cache\", \"Thesaurus\")
			.where(\"Word IN %s+\", words)
		)).map(record => [ record.Word, JSON.parse(record.Result) ])
	);

	const result = [];
	for (const rawWord of words) {
		const word = rawWord.toLowerCase();
		const roll = sb.Utils.random(1, 3);

		// With a chance of 2 in 3, transmute the word into a synonym
		if (thesaurus[word] && roll > 1) {
			result.push(sb.Utils.randArray(thesaurus[word]));
		}
		else {
			result.push(rawWord);
		}
	}

	return {
		reply: result.join(\" \")
	};
})'