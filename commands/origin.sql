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
		20,
		'origin',
		NULL,
		'Fetches the origin of a given emote',
		5000,
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
		'(async function origin (context, ...args) {
	if (args.length === 0) {
		return {
			reply: \"No input provided!\"
		};
	}

	let emote = null;
	let customIndex = null;
	for (let i = args.length - 1; i >= 0; i--) {
		const token = args[i];
		if (/^index:\\d+$/.test(token)) {
			customIndex = Number(token.split(\":\")[1]);
			args.splice(i, 1);
		}
	}

	emote = args.join(\" \");
	if (emote === null) {
		return {
			reply: \"No emote provided!\"
		};
	}

	const emoteData = await sb.Query.getRecordset(rs => rs
		.select(\"Text\", \"Todo\", \"Approved\", \"Emote_Added\")
		.from(\"data\", \"Origin\")
		.where(\"Name COLLATE utf8mb4_bin LIKE %s\", emote)
	);

	if (emoteData.length === 0) {
		return { reply: \"No definition found for given emote!\" };
	}
	if (emoteData.length > 1 && customIndex === null) {
		return {
			reply: `Multiple emotes found for this name! Use \"index:0\" through \"index:${emoteData.length-1}\" to access each one.`
		};
	}

	const specificEmoteData = emoteData[customIndex ?? 0];
	if (!specificEmoteData) {
		return {
			reply: \"No emote definition exists for that index!\"
		};
	}
	else if (!specificEmoteData.Approved) {
		return { reply: \"A definition exists, but has not been approved yet!\" };
	}
	else {
		let string = specificEmoteData.Text;

		if (specificEmoteData.Emote_Added) {
			string += \" (added on \" + specificEmoteData.Emote_Added.sqlDate() + \")\";
		}

		if (specificEmoteData.Todo) {
			string = \"(TODO) \" + string;
		}

		return {
			reply: string
		};
	}
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function origin (context, ...args) {
	if (args.length === 0) {
		return {
			reply: \"No input provided!\"
		};
	}

	let emote = null;
	let customIndex = null;
	for (let i = args.length - 1; i >= 0; i--) {
		const token = args[i];
		if (/^index:\\d+$/.test(token)) {
			customIndex = Number(token.split(\":\")[1]);
			args.splice(i, 1);
		}
	}

	emote = args.join(\" \");
	if (emote === null) {
		return {
			reply: \"No emote provided!\"
		};
	}

	const emoteData = await sb.Query.getRecordset(rs => rs
		.select(\"Text\", \"Todo\", \"Approved\", \"Emote_Added\")
		.from(\"data\", \"Origin\")
		.where(\"Name COLLATE utf8mb4_bin LIKE %s\", emote)
	);

	if (emoteData.length === 0) {
		return { reply: \"No definition found for given emote!\" };
	}
	if (emoteData.length > 1 && customIndex === null) {
		return {
			reply: `Multiple emotes found for this name! Use \"index:0\" through \"index:${emoteData.length-1}\" to access each one.`
		};
	}

	const specificEmoteData = emoteData[customIndex ?? 0];
	if (!specificEmoteData) {
		return {
			reply: \"No emote definition exists for that index!\"
		};
	}
	else if (!specificEmoteData.Approved) {
		return { reply: \"A definition exists, but has not been approved yet!\" };
	}
	else {
		let string = specificEmoteData.Text;

		if (specificEmoteData.Emote_Added) {
			string += \" (added on \" + specificEmoteData.Emote_Added.sqlDate() + \")\";
		}

		if (specificEmoteData.Todo) {
			string = \"(TODO) \" + string;
		}

		return {
			reply: string
		};
	}
})'