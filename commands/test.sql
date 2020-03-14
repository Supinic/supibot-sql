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
		124,
		'test',
		NULL,
		'?',
		10000,
		0,
		1,
		0,
		1,
		'For debugging purposes only :)',
		0,
		0,
		0,
		1,
		1,
		0,
		NULL,
		'async (extra) => {
	await new Promise((resolve) => {
		setTimeout(() => resolve(true), 5000);
	});	

	return {
		reply: \"5 seconds passed 👌\"
	};
}',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async (extra) => {
	await new Promise((resolve) => {
		setTimeout(() => resolve(true), 5000);
	});	

	return {
		reply: \"5 seconds passed 👌\"
	};
}'