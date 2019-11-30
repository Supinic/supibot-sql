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
		5,
		'cookie',
		NULL,
		'Open a random fortune cookie wisdom. Watch out - only one allowed per day, and no refunds! Daily reset occurs at midnight UTC.',
		10000,
		1,
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
		'async (extra, check) => {
	const data = (await sb.Query.getRecordset(rs => rs
		.select(\"Cookie_Today\")
		.from(\"chat_data\", \"Extra_User_Data\")
		.where(\"User_Alias = %n\", extra.user.ID)
	))[0];

	if (check === \"check\") {
		const ready = (data && data.Cookie_Today) ? \"don\'t\" : \"do\";
		return { reply: \"You \" + ready + \" have a cookie available today.\" };
	}
	else if (check === \"gift\" || check === \"give\") {
		const prefix = sb.Config.get(\"COMMAND_PREFIX\");
		return { reply: \"You are trying to gift a cookie - you should use the \" + prefix + \"gift cookie <user> command :)\" };
	}
	
	if (data && data.Cookie_Today) {
		const now = new sb.Date();
		const midnightUTC = new sb.Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate() + 1));
		return { 
			reply: \"You already opened or gifted a fortune cookie today. You can get another one at midnight UTC, which is \" + sb.Utils.timeDelta(midnightUTC)
		};
	}

	const cookieData = (await sb.Query.getRecordset(rs => rs
		.select(\"Text\")
		.from(\"data\", \"Fortune_Cookie\")
		.orderBy(\"RAND() DESC\")
		.limit(1)
	))

	const cookie = cookieData[0];
	if (!cookieData[0]) {
		console.warn(\"No cookie found?\", cookieData);
		return { reply: \"No cookie found? Please report this to @supinic monkaS\" };
	}

	await extra.transaction.query([
		\"INSERT INTO chat_data.Extra_User_Data (User_Alias, Cookie_Today)\", 
		\"VALUES (\" + extra.user.ID + \", 1)\",
		\"ON DUPLICATE KEY UPDATE Cookie_Today = 1\"
	].join(\" \"));

	return { reply: cookie.Text };
}',
		NULL,
		'async (prefix) => {
	return [
		\"Fetch a daily fortune cookie and read its wisdom!\",
		\"Only available once per day, and resets at midnight UTC.\",
		\"No arguments\",
		\"\",
		prefix + \"cookie => <Random wisdom!>\"
	];
}'
	)

ON DUPLICATE KEY UPDATE
	Code = 'async (extra, check) => {
	const data = (await sb.Query.getRecordset(rs => rs
		.select(\"Cookie_Today\")
		.from(\"chat_data\", \"Extra_User_Data\")
		.where(\"User_Alias = %n\", extra.user.ID)
	))[0];

	if (check === \"check\") {
		const ready = (data && data.Cookie_Today) ? \"don\'t\" : \"do\";
		return { reply: \"You \" + ready + \" have a cookie available today.\" };
	}
	else if (check === \"gift\" || check === \"give\") {
		const prefix = sb.Config.get(\"COMMAND_PREFIX\");
		return { reply: \"You are trying to gift a cookie - you should use the \" + prefix + \"gift cookie <user> command :)\" };
	}
	
	if (data && data.Cookie_Today) {
		const now = new sb.Date();
		const midnightUTC = new sb.Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate() + 1));
		return { 
			reply: \"You already opened or gifted a fortune cookie today. You can get another one at midnight UTC, which is \" + sb.Utils.timeDelta(midnightUTC)
		};
	}

	const cookieData = (await sb.Query.getRecordset(rs => rs
		.select(\"Text\")
		.from(\"data\", \"Fortune_Cookie\")
		.orderBy(\"RAND() DESC\")
		.limit(1)
	))

	const cookie = cookieData[0];
	if (!cookieData[0]) {
		console.warn(\"No cookie found?\", cookieData);
		return { reply: \"No cookie found? Please report this to @supinic monkaS\" };
	}

	await extra.transaction.query([
		\"INSERT INTO chat_data.Extra_User_Data (User_Alias, Cookie_Today)\", 
		\"VALUES (\" + extra.user.ID + \", 1)\",
		\"ON DUPLICATE KEY UPDATE Cookie_Today = 1\"
	].join(\" \"));

	return { reply: cookie.Text };
}'