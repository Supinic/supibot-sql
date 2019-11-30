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
		'async (extra, emote) => {
	if (!emote) {
		return { reply: \"An emote must be selected first!\" };
	}
	else if (emote === \"add\") {
		return { reply: \"User addition of emote origin is now only possible on https://supinic.com/origin\" };
	}

	const data = (await sb.Query.getRecordset(rs => rs
		.select(\"Text\", \"Todo\", \"Approved\", \"Emote_Added\")
		.from(\"data\", \"Origin\")
		.where(\"Name COLLATE utf8mb4_bin LIKE %s\", emote)
	))[0];

	console.log(emote, data);

	if (!data) {
		return { reply: \"No definition found for given emote!\" };
	}
	else if (data.Approved === \"0\") {
		return { reply: \"A definition exists, but has not been approved yet...\" };
	}
	else {
		let string = data.Text;
	
		if (data.Emote_Added) {
			string += \" (Added on \" + data.Emote_Added.sqlDate() + \")\";
		}

		if (data.Todo) {
			string = \"(TODO) \" + string;
		}

		return { reply: string };
	}
}',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async (extra, emote) => {
	if (!emote) {
		return { reply: \"An emote must be selected first!\" };
	}
	else if (emote === \"add\") {
		return { reply: \"User addition of emote origin is now only possible on https://supinic.com/origin\" };
	}

	const data = (await sb.Query.getRecordset(rs => rs
		.select(\"Text\", \"Todo\", \"Approved\", \"Emote_Added\")
		.from(\"data\", \"Origin\")
		.where(\"Name COLLATE utf8mb4_bin LIKE %s\", emote)
	))[0];

	console.log(emote, data);

	if (!data) {
		return { reply: \"No definition found for given emote!\" };
	}
	else if (data.Approved === \"0\") {
		return { reply: \"A definition exists, but has not been approved yet...\" };
	}
	else {
		let string = data.Text;
	
		if (data.Emote_Added) {
			string += \" (Added on \" + data.Emote_Added.sqlDate() + \")\";
		}

		if (data.Todo) {
			string = \"(TODO) \" + string;
		}

		return { reply: string };
	}
}'