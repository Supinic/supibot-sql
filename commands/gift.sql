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
		96,
		'gift',
		'[\"give\"]',
		'Gifts a certain something to someone else. Right now, supported parameters are: \"cookie\" - gifts your cooldown for a cookie to someone else!',
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
		'(async function gift (context, type, target) {
	if (!type) {
		return { reply: \"No type provided!\" };
	}
	else if (!target) {
		return { reply: \"No user target provided!\" };
	}

	const targetUser = await sb.User.get(target, true);
	if (!targetUser) {
		return { reply: \"Provided user has not been found!\" };
	}

	switch (type) {
		case \"cookie\": {
			if (targetUser.ID === sb.Config.get(\"SELF_ID\")) {
				return { reply: \"I appreciate the gesture, but thanks, I don\'t eat sweets :)\" };
			}

			const sourceUserCheck = await sb.Query.getRecordset(rs => rs
				.select(\"Cookie_Today\", \"Cookie_Is_Gifted\")
				.from(\"chat_data\", \"Extra_User_Data\")
				.where(\"User_Alias = %n\", context.user.ID)
				.single()
			);

			if (!sourceUserCheck) {
				await sb.Query.raw([
					\"INSERT INTO chat_data.Extra_User_Data (User_Alias)\",
					\"VALUES (\" + context.user.ID + \")\"
				].join(\" \"));
			}
			else if (sourceUserCheck.Cookie_Today) {
				return { reply: \"You already ate or gifted away your cookie today, so you can\'t gift it to someone else!\" };
			}
			else if (sourceUserCheck.Cookie_Is_Gifted) {
				return { reply: \"That cookie was gifted to you! Eat it, don\'t give it away!\" };
			}

			const targetUserCheck = await sb.Query.getRecordset(rs => rs
				.select(\"Cookie_Today\")
				.from(\"chat_data\", \"Extra_User_Data\")
				.where(\"User_Alias = %n\", targetUser.ID)
				.single()
			);

			if (!targetUserCheck) {
				return {
					reply: \"That user has never eaten a cookie before, so gifting them one is kinda pointless!\"
				};
			}
			else if (!targetUserCheck.Cookie_Today) {
				return {
					reply: \"That user hasn\'t eaten their cookie today, so you would be wasting your gift! Get them to eat it!\"
				};
			}

			await sb.Query.raw([
				\"INSERT INTO chat_data.Extra_User_Data (User_Alias, Cookie_Today,  Cookie_Gifts_Sent)\",
				\"VALUES (\" + context.user.ID + \", 1, 1)\",
				\"ON DUPLICATE KEY UPDATE Cookie_Today = 1, Cookie_Gifts_Sent = Cookie_Gifts_Sent + 1\"
			].join(\" \"));

			await sb.Query.raw([
				\"UPDATE chat_data.Extra_User_Data\",
				\"SET Cookie_Today = 0, Cookie_Is_Gifted = 1, Cookie_Gifts_Received = Cookie_Gifts_Received + 1\",
				\"WHERE User_Alias = \" + targetUser.ID
			].join(\" \"));

			return { reply: \"Successfully given your cookie for today to \" + targetUser.Name + \" :)\" };
		}

		default: return { reply: \"Target type cannot be gifted (yet, at least).\" };
	}
})',
		'Gifts another user some item. Depends on the type chosen.

$gift cookie <user> => Gifts your daily cookie to that user. They must have eaten their own for today first.',
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function gift (context, type, target) {
	if (!type) {
		return { reply: \"No type provided!\" };
	}
	else if (!target) {
		return { reply: \"No user target provided!\" };
	}

	const targetUser = await sb.User.get(target, true);
	if (!targetUser) {
		return { reply: \"Provided user has not been found!\" };
	}

	switch (type) {
		case \"cookie\": {
			if (targetUser.ID === sb.Config.get(\"SELF_ID\")) {
				return { reply: \"I appreciate the gesture, but thanks, I don\'t eat sweets :)\" };
			}

			const sourceUserCheck = await sb.Query.getRecordset(rs => rs
				.select(\"Cookie_Today\", \"Cookie_Is_Gifted\")
				.from(\"chat_data\", \"Extra_User_Data\")
				.where(\"User_Alias = %n\", context.user.ID)
				.single()
			);

			if (!sourceUserCheck) {
				await sb.Query.raw([
					\"INSERT INTO chat_data.Extra_User_Data (User_Alias)\",
					\"VALUES (\" + context.user.ID + \")\"
				].join(\" \"));
			}
			else if (sourceUserCheck.Cookie_Today) {
				return { reply: \"You already ate or gifted away your cookie today, so you can\'t gift it to someone else!\" };
			}
			else if (sourceUserCheck.Cookie_Is_Gifted) {
				return { reply: \"That cookie was gifted to you! Eat it, don\'t give it away!\" };
			}

			const targetUserCheck = await sb.Query.getRecordset(rs => rs
				.select(\"Cookie_Today\")
				.from(\"chat_data\", \"Extra_User_Data\")
				.where(\"User_Alias = %n\", targetUser.ID)
				.single()
			);

			if (!targetUserCheck) {
				return {
					reply: \"That user has never eaten a cookie before, so gifting them one is kinda pointless!\"
				};
			}
			else if (!targetUserCheck.Cookie_Today) {
				return {
					reply: \"That user hasn\'t eaten their cookie today, so you would be wasting your gift! Get them to eat it!\"
				};
			}

			await sb.Query.raw([
				\"INSERT INTO chat_data.Extra_User_Data (User_Alias, Cookie_Today,  Cookie_Gifts_Sent)\",
				\"VALUES (\" + context.user.ID + \", 1, 1)\",
				\"ON DUPLICATE KEY UPDATE Cookie_Today = 1, Cookie_Gifts_Sent = Cookie_Gifts_Sent + 1\"
			].join(\" \"));

			await sb.Query.raw([
				\"UPDATE chat_data.Extra_User_Data\",
				\"SET Cookie_Today = 0, Cookie_Is_Gifted = 1, Cookie_Gifts_Received = Cookie_Gifts_Received + 1\",
				\"WHERE User_Alias = \" + targetUser.ID
			].join(\" \"));

			return { reply: \"Successfully given your cookie for today to \" + targetUser.Name + \" :)\" };
		}

		default: return { reply: \"Target type cannot be gifted (yet, at least).\" };
	}
})'