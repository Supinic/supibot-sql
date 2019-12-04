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
		185,
		'record',
		NULL,
		'Checks for various max/min records of various sources.',
		10000,
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
		'(async function record (context, type, target) {
	if (!type) {
		return {
			reply: \"No type provided!\"
		};
	}

	type = type.toLowerCase();
	target = target || context.user;
	const userData = await sb.User.get(target);

	switch (type) {
		case \"afk\":
			if (userData.ID !== context.user.ID) {
				return { 
					reply: \"Cannot be checked on people other than you!\"
				};
			}

			const data = await sb.Query.getRecordset(rs => rs
				.select(\"Ended\")
				.select(\"(UNIX_TIMESTAMP(Ended) - UNIX_TIMESTAMP(Started)) AS Seconds\")
				.from(\"chat_data\", \"AFK\")
				.where(\"User_Alias = %n\", userData.ID)
				.where(\"Ended IS NOT NULL\")
				.orderBy(\"Seconds DESC\")
				.limit(1)
				.single()
			);
			
			if (!data) {
				return {
					reply: \"No AFK status found!\"
				};
			}
			
			const formatted = sb.Utils.formatTime(sb.Utils.round(data.Seconds, 0), false);
			const delta = sb.Utils.timeDelta(data.Ended);
			return {
				reply: `Your longest AFK period lasted for ${formatted} - this was ${delta}.`
			};

		default: return { reply: \"Invalid type provided!\" };
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function record (context, type, target) {
	if (!type) {
		return {
			reply: \"No type provided!\"
		};
	}

	type = type.toLowerCase();
	target = target || context.user;
	const userData = await sb.User.get(target);

	switch (type) {
		case \"afk\":
			if (userData.ID !== context.user.ID) {
				return { 
					reply: \"Cannot be checked on people other than you!\"
				};
			}

			const data = await sb.Query.getRecordset(rs => rs
				.select(\"Ended\")
				.select(\"(UNIX_TIMESTAMP(Ended) - UNIX_TIMESTAMP(Started)) AS Seconds\")
				.from(\"chat_data\", \"AFK\")
				.where(\"User_Alias = %n\", userData.ID)
				.where(\"Ended IS NOT NULL\")
				.orderBy(\"Seconds DESC\")
				.limit(1)
				.single()
			);
			
			if (!data) {
				return {
					reply: \"No AFK status found!\"
				};
			}
			
			const formatted = sb.Utils.formatTime(sb.Utils.round(data.Seconds, 0), false);
			const delta = sb.Utils.timeDelta(data.Ended);
			return {
				reply: `Your longest AFK period lasted for ${formatted} - this was ${delta}.`
			};

		default: return { reply: \"Invalid type provided!\" };
	};
})'