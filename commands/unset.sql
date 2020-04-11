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
		63,
		'unset',
		NULL,
		NULL,
		'Unsets a certain variable that you have created (e.g. reminders)',
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
		1,
		0,
		'({
	variables: [
		{
			names: [\"notify\", \"reminder\"],
			description: \"Unsets an active reminder either set by you or for you.\"
		},
		{
			names: [\"suggest\", \"suggestion\"],
			description: \"Marks an active suggestion created by you to be \\\"Dismissed by author\\\".\"
		},
		{
			names: [\"location\"],
			description: \"Removes your location if you have set one before.\"
		}
	]
})',
		'(async function unset (context, type, ID) {
	if (!type) {
		return {
			success: false,
			reply: \"No type provided!\"
		};
	}

	type = type.toLowerCase();
	if (ID === \"last\") {
		let result = null;
		if (type === \"notify\" || type === \"reminder\") {
			result = await sb.Query.getRecordset(rs => rs
				.select(\"ID\")
				.from(\"chat_data\", \"Reminder\")
				.where(\"User_From = %n\", context.user.ID)
				.where(\"Active = %b\", true)
				.orderBy(\"ID DESC\")
				.limit(1)
				.single()
			);

		}
		else if (type === \"suggestion\" || type === \"suggest\") {
			result = await sb.Query.getRecordset(rs => rs
				.select(\"ID\")
				.from(\"data\", \"Suggestion\")
				.where(\"User_Alias = %n\", context.user.ID)
				.orderBy(\"ID DESC\")
				.limit(1)
				.single()
			);
		}
		else {
			return { reply: `Unsupported type for the keyword \"last\"!` };
		}

		if (!result) {
			return { reply: `No suitable \"last\" ${type} ID for you has been found!` };
		}
		else {
			ID = result.ID;
		}
	}

	ID = Number(ID);
	switch (type) {
		case \"notify\":
		case \"reminder\": {
			let row = await sb.Query.getRow(\"chat_data\", \"Reminder\");
			try {
				await row.load(ID);
			}
			catch {
				return { reply: \"ID does not exist!\" };
			}

			if (row.values.User_From !== context.user.ID && row.values.User_To !== context.user.ID ) {
				return { reply: \"That reminder was not created by you or set for you!\" };
			}
			else if (!row.values.Active) {
				return { reply: \"That reminder is already deactivated!\" };
			}
			else if (context.channel?.ID && !row.values.Schedule && row.values.User_To === context.user.ID) {
				return { reply: \"Good job, trying to unset a reminder that just fired PepeLaugh\" };
			}
			else {
				await sb.Reminder.get(ID).deactivate(true);
				return { reply: \"Reminder ID \" + ID + \" unset successfully.\" };
			}
		}

		case \"suggest\":
		case \"suggestion\": {
			let row = await sb.Query.getRow(\"data\", \"Suggestion\");
			try {
				await row.load(ID);
			}
			catch {
				return { reply: \"ID does not exist!\" };
			}

			if (row.values.User_Alias !== context.user.ID) {
				return { reply: \"That suggestion was not created by you!\" };
			}
			else if (row.values.Status === \"Dismissed by author\") {
				return { reply: \"That reminder is already deactivated!\" };
			}
			else {
				row.values.Priority = null;
				row.values.Status = \"Dismissed by author\";
				await row.save();
				return { reply: \"Suggestion ID \" + ID + \" has been flagged as \\\"Dismissed by author\\\".\" };
			}
		}

		case \"location\": {
			context.user.Data.location = null;

			await context.user.saveProperty(\"Data\", context.user.Data);
			return {
				reply: \"Your location has been unset successfully!\"
			};
		}

		default: return {
			success: false,
			reply: \"Unrecognized target!\"
		};
	}
})',
		NULL,
		'async (prefix) => {
	const row = await sb.Query.getRow(\"chat_data\", \"Command\");
	await row.load(63);
	
	const { variables } = eval(row.values.Static_Data);
	const list = variables.map(i => `<li><code>${i.names.join(\"/\")}</code> ${i.description}</li>`).join(\"\");

	return [
		\"Unsets a variable that you have set in Supibot beforehand.\",
		\"\",

		`<code>${prefix}unset (variable) (ID)</code>`,
		`Unsets the variable of the given type, and the given ID.`,
		\"\",
		

		`<code>${prefix}unset (variable) last</code>`,
		`If applicable, unsets the last variable of given that type that you have set.`,
		\"\",

		\"List of variables:\",
		`<ul>${list}</ul>`		
	];	
}'
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function unset (context, type, ID) {
	if (!type) {
		return {
			success: false,
			reply: \"No type provided!\"
		};
	}

	type = type.toLowerCase();
	if (ID === \"last\") {
		let result = null;
		if (type === \"notify\" || type === \"reminder\") {
			result = await sb.Query.getRecordset(rs => rs
				.select(\"ID\")
				.from(\"chat_data\", \"Reminder\")
				.where(\"User_From = %n\", context.user.ID)
				.where(\"Active = %b\", true)
				.orderBy(\"ID DESC\")
				.limit(1)
				.single()
			);

		}
		else if (type === \"suggestion\" || type === \"suggest\") {
			result = await sb.Query.getRecordset(rs => rs
				.select(\"ID\")
				.from(\"data\", \"Suggestion\")
				.where(\"User_Alias = %n\", context.user.ID)
				.orderBy(\"ID DESC\")
				.limit(1)
				.single()
			);
		}
		else {
			return { reply: `Unsupported type for the keyword \"last\"!` };
		}

		if (!result) {
			return { reply: `No suitable \"last\" ${type} ID for you has been found!` };
		}
		else {
			ID = result.ID;
		}
	}

	ID = Number(ID);
	switch (type) {
		case \"notify\":
		case \"reminder\": {
			let row = await sb.Query.getRow(\"chat_data\", \"Reminder\");
			try {
				await row.load(ID);
			}
			catch {
				return { reply: \"ID does not exist!\" };
			}

			if (row.values.User_From !== context.user.ID && row.values.User_To !== context.user.ID ) {
				return { reply: \"That reminder was not created by you or set for you!\" };
			}
			else if (!row.values.Active) {
				return { reply: \"That reminder is already deactivated!\" };
			}
			else if (context.channel?.ID && !row.values.Schedule && row.values.User_To === context.user.ID) {
				return { reply: \"Good job, trying to unset a reminder that just fired PepeLaugh\" };
			}
			else {
				await sb.Reminder.get(ID).deactivate(true);
				return { reply: \"Reminder ID \" + ID + \" unset successfully.\" };
			}
		}

		case \"suggest\":
		case \"suggestion\": {
			let row = await sb.Query.getRow(\"data\", \"Suggestion\");
			try {
				await row.load(ID);
			}
			catch {
				return { reply: \"ID does not exist!\" };
			}

			if (row.values.User_Alias !== context.user.ID) {
				return { reply: \"That suggestion was not created by you!\" };
			}
			else if (row.values.Status === \"Dismissed by author\") {
				return { reply: \"That reminder is already deactivated!\" };
			}
			else {
				row.values.Priority = null;
				row.values.Status = \"Dismissed by author\";
				await row.save();
				return { reply: \"Suggestion ID \" + ID + \" has been flagged as \\\"Dismissed by author\\\".\" };
			}
		}

		case \"location\": {
			context.user.Data.location = null;

			await context.user.saveProperty(\"Data\", context.user.Data);
			return {
				reply: \"Your location has been unset successfully!\"
			};
		}

		default: return {
			success: false,
			reply: \"Unrecognized target!\"
		};
	}
})'