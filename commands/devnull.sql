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
		205,
		'devnull',
		'[\"/dev/null\", \"null\"]',
		'Discards all output. Only usable in pipes.',
		0,
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
		0,
		NULL,
		'(async function devnull (context) {
	if (!context.append.pipe) {
		return {
			reply: \"This command cannot be used outside of pipe!\"
		};
	}

	return null;
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function devnull (context) {
	if (!context.append.pipe) {
		return {
			reply: \"This command cannot be used outside of pipe!\"
		};
	}

	return null;
})'