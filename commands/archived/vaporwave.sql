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
		159,
		'vaporwave',
		'[\"vw\"]',
		'archived,mention,pipe',
		'ＡＥＳＴＨＥＴＩＣ ＣＯＭＭＡＮＤ ＴＨＡＴ ＴＵＲＮＳ ＮＯＲＭＡＬ ＴＥＸＴ ＩＮＴＯ ＴＨＩＳ',
		10000,
		NULL,
		NULL,
		'(async function vaporwave () { 
	return {
		reply: \"Command deprecated. Use \\\"$texttransform vaporwave\\\" instead, or $tt vw for short.\"
	};
})',
		NULL,
		'supinic/supibot-sql'
	)