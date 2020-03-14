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
		55,
		'toggleban',
		NULL,
		'Toggles the status of an existing ban based on the ID.',
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
		1,
		NULL,
		'async (extra, ID) => {
	if (!ID  || !Number(ID)) {
		return { reply: \"No or invalid ID provided\" };
	}

	const ban = sb.Filter.get(Number(ID));
	await ban.toggle();

	return { reply: \"Ban ID \" + ban.ID + \" is now \" + (ban.Active ? \"\" : \"in\") + \"active.\" };
}',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async (extra, ID) => {
	if (!ID  || !Number(ID)) {
		return { reply: \"No or invalid ID provided\" };
	}

	const ban = sb.Filter.get(Number(ID));
	await ban.toggle();

	return { reply: \"Ban ID \" + ban.ID + \" is now \" + (ban.Active ? \"\" : \"in\") + \"active.\" };
}'