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
		63,
		'unset',
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
		0,
		'(async function unset (context, type, ID) {
	if ((!type && !ID) || Number(type) || (!Number(ID) && ID !== \"last\")) {
		const prefix = sb.Config.get(\"COMMAND_PREFIX\");
		return {
			reply: `The correct syntax is: ${prefix}unset <type> <ID> or ${prefix}unset <type> \"last\". Check the command\'s help for more info.`
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
			catch (e) {
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
			catch (e) {
				return { reply: \"ID does not exist!\" };
			}

			if (row.values.User_Alias !== context.user.ID) {
				return { reply: \"That suggestion was not created by you!\" };
			}
			else if (row.values.Status === \"Dismissed by author\") {
				return { reply: \"That reminder is already deactivated!\" };
			}
			else {
				row.values.Status = \"Dismissed by author\";
				await row.save();
				return { reply: \"Suggestion ID \" + ID + \" has been flagged as \\\"Dismissed by author\\\".\" };
			}
		}

		default: return { reply: \"Unrecognized target\" };
	}
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function unset (context, type, ID) {
	if ((!type && !ID) || Number(type) || (!Number(ID) && ID !== \"last\")) {
		const prefix = sb.Config.get(\"COMMAND_PREFIX\");
		return {
			reply: `The correct syntax is: ${prefix}unset <type> <ID> or ${prefix}unset <type> \"last\". Check the command\'s help for more info.`
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
			catch (e) {
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
			catch (e) {
				return { reply: \"ID does not exist!\" };
			}

			if (row.values.User_Alias !== context.user.ID) {
				return { reply: \"That suggestion was not created by you!\" };
			}
			else if (row.values.Status === \"Dismissed by author\") {
				return { reply: \"That reminder is already deactivated!\" };
			}
			else {
				row.values.Status = \"Dismissed by author\";
				await row.save();
				return { reply: \"Suggestion ID \" + ID + \" has been flagged as \\\"Dismissed by author\\\".\" };
			}
		}

		default: return { reply: \"Unrecognized target\" };
	}
})'