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
		212,
		'kanji',
		NULL,
		'ping,pipe',
		'Posts a quick summary of a given Kanji(?) character',
		10000,
		NULL,
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
		'supinic/supibot-sql'
	)