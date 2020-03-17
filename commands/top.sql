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
		Static_Data,
		Code,
		Examples,
		Dynamic_Description
	)
VALUES
	(
		42,
		'top',
		NULL,
		'Posts the top X (implicitly 10) users by chat lines sent in the context of current channel.',
		60000,
		0,
		0,
		0,
		1,
		NULL,
		0,
		0,
		0,
		0,
		1,
		0,
		NULL,
		'(async function top (extra, limit) {
	if (!Number.isFinite(Number(limit))) {
		limit = 3;
	}
	if (limit > 10) {
		return { reply: \"Limit set too high!\" };
	}

	const channels = (extra.channel.ID === 7 || extra.channel.ID === 8)
		? [7, 8, 46]
		: [extra.channel.ID];

	const top = await sb.Query.getRecordset(rs => rs
		.select(\"SUM(Message_Count) AS Total\")
		.select(\"User_Alias.Name AS Name\")
		.from(\"chat_data\", \"Message_Meta_User_Alias\")
		.join(\"chat_data\", \"User_Alias\")
		.where(\"Channel IN %n+\", channels)
		.groupBy(\"User_Alias\")
		.orderBy(\"SUM(Message_Count) DESC\")
		.limit(limit)
	);

	const chatters = top.map((i, ind) => {
		const name = i.Name[0] + `\\u{E0000}` + i.Name.slice(1);
		return `#${ind + 1}: ${name} (${i.Total})`;
	}).join(\", \");

	return {
		reply: `Top ${limit} chatters: ${chatters}`
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function top (extra, limit) {
	if (!Number.isFinite(Number(limit))) {
		limit = 3;
	}
	if (limit > 10) {
		return { reply: \"Limit set too high!\" };
	}

	const channels = (extra.channel.ID === 7 || extra.channel.ID === 8)
		? [7, 8, 46]
		: [extra.channel.ID];

	const top = await sb.Query.getRecordset(rs => rs
		.select(\"SUM(Message_Count) AS Total\")
		.select(\"User_Alias.Name AS Name\")
		.from(\"chat_data\", \"Message_Meta_User_Alias\")
		.join(\"chat_data\", \"User_Alias\")
		.where(\"Channel IN %n+\", channels)
		.groupBy(\"User_Alias\")
		.orderBy(\"SUM(Message_Count) DESC\")
		.limit(limit)
	);

	const chatters = top.map((i, ind) => {
		const name = i.Name[0] + `\\u{E0000}` + i.Name.slice(1);
		return `#${ind + 1}: ${name} (${i.Total})`;
	}).join(\", \");

	return {
		reply: `Top ${limit} chatters: ${chatters}`
	};
})'