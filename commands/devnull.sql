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
		205,
		'devnull',
		'[\"/dev/null\", \"null\"]',
		'ping,pipe',
		'Discards all output. Only usable in pipes.',
		0,
		NULL,
		NULL,
		'(async function devnull (context) {
	if (!context.append.pipe) {
		return {
			reply: \"This command cannot be used outside of pipe!\"
		};
	}

	return null;
})',
		NULL
	)