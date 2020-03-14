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
		159,
		'vaporwave',
		'[\"vw\"]',
		'ＡＥＳＴＨＥＴＩＣ ＣＯＭＭＡＮＤ ＴＨＡＴ ＴＵＲＮＳ ＮＯＲＭＡＬ ＴＥＸＴ ＩＮＴＯ ＴＨＩＳ',
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
		1,
		NULL,
		'(async function vaporwave () { 
	return {
		reply: \"Command deprecated. Use \\\"$texttransform vaporwave\\\" instead, or $tt vw for short.\"
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function vaporwave () { 
	return {
		reply: \"Command deprecated. Use \\\"$texttransform vaporwave\\\" instead, or $tt vw for short.\"
	};
})'