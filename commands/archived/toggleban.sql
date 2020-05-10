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
		55,
		'toggleban',
		NULL,
		'archived,ping,pipe,system,whitelist',
		'Toggles the status of an existing ban based on the ID.',
		0,
		NULL,
		NULL,
		'async (extra, ID) => {
	if (!ID  || !Number(ID)) {
		return { reply: \"No or invalid ID provided\" };
	}

	const ban = sb.Filter.get(Number(ID));
	await ban.toggle();

	return { reply: \"Ban ID \" + ban.ID + \" is now \" + (ban.Active ? \"\" : \"in\") + \"active.\" };
}',
		NULL
	)