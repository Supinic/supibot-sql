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
		81,
		'cerebot',
		NULL,
		'pipe,skip-banphrase,system,whitelist',
		'Posts a command for cerebot to execute.',
		5000,
		NULL,
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
		'supinic/supibot-sql'
	)