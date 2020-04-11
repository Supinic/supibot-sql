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
		212,
		'kanji',
		NULL,
		NULL,
		'Posts a quick summary of a given Kanji(?) character',
		10000,
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
		0,
		NULL,
		'(async function kanji (context, character) {
	if (!character) {
		return { 
			success: false,
			reply: \"Pepega\"
		};
	}

	const data = await sb.Got({
		prefixUrl: \"https://app.kanjialive.com/api\",
		url: \"kanji/\" + character
	}).json();

	if (data.Error) {
		return {
			success: false,
			reply: \"Error: \" + data.Error
		};
	}

	return {
		reply: `${data.ka_utf} (${data.kunyomi}; ${data.onyomi}): ${data.meaning}.`
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function kanji (context, character) {
	if (!character) {
		return { 
			success: false,
			reply: \"Pepega\"
		};
	}

	const data = await sb.Got({
		prefixUrl: \"https://app.kanjialive.com/api\",
		url: \"kanji/\" + character
	}).json();

	if (data.Error) {
		return {
			success: false,
			reply: \"Error: \" + data.Error
		};
	}

	return {
		reply: `${data.ka_utf} (${data.kunyomi}; ${data.onyomi}): ${data.meaning}.`
	};
})'