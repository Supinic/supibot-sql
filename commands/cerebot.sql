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
		'(async function cerebot (context, ...args) {
	let message = args.join(\" \").trim();
	if (!message.startsWith(\"!\")) {
		message = \"!\" + message;
	}

	await sb.Channel.get(7).send(message);
	return null;
})',
		NULL,
		'supinic/supibot-sql'
	)