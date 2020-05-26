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
		20,
		'origin',
		NULL,
		'ping,pipe',
		'Fetches the origin of a given emote',
		10000,
		NULL,
		NULL,
		'(async function origin (context, ...args) {
	if (args.length === 0) {
		return {
			success: false,
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
			success: false,
			reply: \"No emote provided!\"
		};
	}

	const emoteData = await sb.Query.getRecordset(rs => rs
		.select(\"Text\", \"Tier\", \"Type\", \"Todo\", \"Approved\", \"Emote_Added\")
		.from(\"data\", \"Origin\")
		.where(\"Name COLLATE utf8mb4_bin LIKE %s\", emote)
	);

	if (emoteData.length === 0) {
		return {
			success: false,
			reply: \"No definition found for given emote!\"
		};
	}
	else if (emoteData.length > 1 && customIndex === null) {
		return {
			reply: `Multiple emotes found for this name! Use \"index:0\" through \"index:${emoteData.length-1}\" to access each one.`,
			cooldown: { length: 2500 }
		};
	}

	const data = emoteData[customIndex ?? 0];
	if (!data) {
		return {
			reply: \"No emote definition exists for that index!\"
		};
	}
	else if (!data.Approved) {
		return { reply: \"A definition exists, but has not been approved yet!\" };
	}
	else {
		const type = (data.Tier) ? `T${data.Tier}` : \"\";
		let string = `${type} ${data.Type} emote: ${data.Text}`;

		if (data.Emote_Added) {
			string += \" (emote added on \" + data.Emote_Added.sqlDate() + \")\";
		}
		if (data.Todo) {
			string = \"(TODO) \" + string;
		}

		return {
			reply: string
		};
	}
})',
		NULL,
		'supinic/supibot-sql'
	)