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
		114,
		'verify',
		NULL,
		'Verifies a user to be able to use a specific command based on some requirement.',
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
		0,
		'async (extra, type, user, link) => {
	if (!type || !user || !link) {
		return { reply: \"Some arguments are missing\" };
	}

	const allowedTypes = [\"dog\", \"cat\"];
	if (!allowedTypes.includes(type)) {
		return { reply: \"Unknown type!\" };
	}

	const userData = await sb.User.get(user, true);
	if (!userData) {
		return { reply: \"Unknown user!\" };
	}

	const commands = {
		dog: [79, 82],
		cat: [78, 83]
	};

	for (const commandID of commands[type]) {
		const row = await sb.Query.getRow(\"chat_data\", \"Filter\");
		row.setValues({
			User_Alias: userData.ID,
			Type: \"Whitelist\",
			Command: commandID,
			Notes: link
		});

		await row.save();
	}

	await sb.Command.get(\"reload\").execute(null, \"filters\");

	return { reply: \"All went well :)\" };
}',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async (extra, type, user, link) => {
	if (!type || !user || !link) {
		return { reply: \"Some arguments are missing\" };
	}

	const allowedTypes = [\"dog\", \"cat\"];
	if (!allowedTypes.includes(type)) {
		return { reply: \"Unknown type!\" };
	}

	const userData = await sb.User.get(user, true);
	if (!userData) {
		return { reply: \"Unknown user!\" };
	}

	const commands = {
		dog: [79, 82],
		cat: [78, 83]
	};

	for (const commandID of commands[type]) {
		const row = await sb.Query.getRow(\"chat_data\", \"Filter\");
		row.setValues({
			User_Alias: userData.ID,
			Type: \"Whitelist\",
			Command: commandID,
			Notes: link
		});

		await row.save();
	}

	await sb.Command.get(\"reload\").execute(null, \"filters\");

	return { reply: \"All went well :)\" };
}'