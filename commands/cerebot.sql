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
		81,
		'cerebot',
		NULL,
		NULL,
		'Posts a command for cerebot to execute.',
		5000,
		0,
		0,
		1,
		1,
		NULL,
		0,
		0,
		0,
		0,
		1,
		0,
		0,
		NULL,
		'async (extra, ...args) => {
	let message = args.join(\" \").trim();
	if (message[0] !== \"!\") {
		message = \"!\" + message;
	}

	sb.Master.send(message, 7);
	return { reply: null };
}',
		NULL,
		NULL
	)