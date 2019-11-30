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
		178,
		'cytube',
		NULL,
		'Posts the link to channel\'s cytube',
		15000,
		0,
		0,
		0,
		1,
		NULL,
		0,
		0,
		0,
		1,
		1,
		0,
		'(async function cytube () {
	return {
		reply: \"Check it out here: https://cytu.be/r/forsenoffline\"
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function cytube () {
	return {
		reply: \"Check it out here: https://cytu.be/r/forsenoffline\"
	};
})'