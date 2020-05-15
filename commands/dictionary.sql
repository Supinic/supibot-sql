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
		Dynamic_Description
	)
VALUES
	(
		23,
		'dictionary',
		'[\"define\", \"def\", \"dict\"]',
		'ping,pipe',
		'Fetches the dictionary definition of a word. Add a number at the end to access specific definition index if the given word has multiple definitions.',
		10000,
		NULL,
		NULL,
		'(async function dictionary (context, ...args) {
	let specificIndex = 0;
	for (let i = 0; i < args.length; i++) {
		const token = args[i];
		if (/^index:\\d+$/.test(token)) {
			specificIndex = Number(token.replace(\"index:\", \"\"));
			args.splice(i, 1);
		}
	}

	const term = args[0];
	const { body, statusCode } = await sb.Got({
		url: `https://owlbot.info/api/v2/dictionary/${term}`,
		searchParams: \"format=json\",
		throwHttpErrors: false
	});

	if (statusCode !== 200) {
		return {
			success: false,
			reply: `Dictionary API returned error ${statusCode}!`
		};
	}
	
	let data = null;
	try {
		data = JSON.parse(body);
	}
	catch (e) {
		return {
			success: false,
			reply: `Dictionary API cannot return proper data! (asked for JSON, got HTML)`
		};
	}

	if (data.length === 1 && data[0].message) {
		return {
			reply: data[0].message
		};
	}
	else if (data.length === 0) {
		return {
			reply: \"There is no such defintion!\"
		};
	}
	else if (data.length === 1) {
		return {
			reply: `(${data[0].type}): ${data[0].definition}`
		};
	}
	else {
		const plural  = (data.length - 1 === 1) ? \"\" : \"s\";
		const extraText = (specificIndex === 0)
			? \"(\" + (data.length - 1) + \" more definition\" + plural + \" found\" + \")\"
			: \"\";

		if (specificIndex < 0 || specificIndex >= data.length) {
			return {
				reply: \"Specified ID is out of bounds!\"
			};
		}
		else {
			return {
				reply: `(${data[specificIndex].type}): ${data[specificIndex].definition} ${extraText}`
			};
		}
	}
})',
		NULL
	)