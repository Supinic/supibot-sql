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
		96,
		'gift',
		'[\"give\"]',
		NULL,
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
		0,
		NULL,
		'(async function gift (context, type, target) {
	if (!type) {
		return { reply: \"No type provided!\" };
	}
	else if (!target) {
		return { reply: \"No user target provided!\" };
	}

	const targetUserData = await sb.User.get(target, true);
	if (!targetUserData) {
		return { reply: \"Provided user has not been found!\" };
	}

	switch (type) {
		case \"cookie\": {
			if (targetUserData.ID === sb.Config.get(\"SELF_ID\")) {
				return { reply: \"I appreciate the gesture, but thanks, I don\'t eat sweets :)\" };
			}

			const [sourceUser, targetUser] = await Promise.all([
				(async function getSourceRow () {
					const row = await sb.Query.getRow(\"chat_data\", \"Extra_User_Data\");
					await row.load(context.user.ID, true);
					if (!row.loaded) {
						await row.save();
					}

					return row;
				})(),
				(async function getTargetRow () {
					const row = await sb.Query.getRow(\"chat_data\", \"Extra_User_Data\");
					await row.load(targetUserData.ID, true);
					if (!row.loaded) {
						await row.save();
					}

					return row;
				})()
			]);

			if (sourceUser.values.Cookie_Today) {
				return {
					reply: \"You already ate or gifted away your cookie today, so you can\'t gift it to someone else!\"
				};
			}
			else if (sourceUser.values.Cookie_Is_Gifted) {
				return {
					reply: \"That cookie was gifted to you! Eat it, don\'t give it away!\"
				};
			}
			else if (!targetUser.values.Cookie_Today) {
				return {
					reply: \"That user hasn\'t eaten their cookie today, so you would be wasting your gift! Get them to eat it!\"
				};
			}

			sourceUser.setValues({
				Cookie_Today: true,
				Cookie_Gifts_Sent: sourceUser.values.Cookie_Gifts_Sent + 1
			});

			targetUser.setValues({
				Cookie_Today: false,
				Cookie_Is_Gifted: true,
				Cookie_Gifts_Received: targetUser.values.Cookie_Gifts_Received + 1
			});

			await Promise.all([
				sourceUser.save(),
				targetUser.save()
			]);

			sb.CooldownManager.unset(null, targetUser.ID, sb.Command.get(\"cookie\").ID);

			return {
				reply: \"Successfully given your cookie for today to \" + targetUserData.Name + \" :)\"
			};
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

	const targetUserData = await sb.User.get(target, true);
	if (!targetUserData) {
		return { reply: \"Provided user has not been found!\" };
	}

	switch (type) {
		case \"cookie\": {
			if (targetUserData.ID === sb.Config.get(\"SELF_ID\")) {
				return { reply: \"I appreciate the gesture, but thanks, I don\'t eat sweets :)\" };
			}

			const [sourceUser, targetUser] = await Promise.all([
				(async function getSourceRow () {
					const row = await sb.Query.getRow(\"chat_data\", \"Extra_User_Data\");
					await row.load(context.user.ID, true);
					if (!row.loaded) {
						await row.save();
					}

					return row;
				})(),
				(async function getTargetRow () {
					const row = await sb.Query.getRow(\"chat_data\", \"Extra_User_Data\");
					await row.load(targetUserData.ID, true);
					if (!row.loaded) {
						await row.save();
					}

					return row;
				})()
			]);

			if (sourceUser.values.Cookie_Today) {
				return {
					reply: \"You already ate or gifted away your cookie today, so you can\'t gift it to someone else!\"
				};
			}
			else if (sourceUser.values.Cookie_Is_Gifted) {
				return {
					reply: \"That cookie was gifted to you! Eat it, don\'t give it away!\"
				};
			}
			else if (!targetUser.values.Cookie_Today) {
				return {
					reply: \"That user hasn\'t eaten their cookie today, so you would be wasting your gift! Get them to eat it!\"
				};
			}

			sourceUser.setValues({
				Cookie_Today: true,
				Cookie_Gifts_Sent: sourceUser.values.Cookie_Gifts_Sent + 1
			});

			targetUser.setValues({
				Cookie_Today: false,
				Cookie_Is_Gifted: true,
				Cookie_Gifts_Received: targetUser.values.Cookie_Gifts_Received + 1
			});

			await Promise.all([
				sourceUser.save(),
				targetUser.save()
			]);

			sb.CooldownManager.unset(null, targetUser.ID, sb.Command.get(\"cookie\").ID);

			return {
				reply: \"Successfully given your cookie for today to \" + targetUserData.Name + \" :)\"
			};
		}

		default: return { reply: \"Target type cannot be gifted (yet, at least).\" };
	}
})'