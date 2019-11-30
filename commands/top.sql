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
		1,
		1,
		0,
		'async (extra, limit) => {
	if (!Number.isFinite(Number(limit))) {
		limit = 10;
	}
	if (limit > 10) {
		return { reply: \"Limit set too high!\" };
	}

	const channels = (extra.channel.ID === 7 || extra.channel.ID === 8)
		? [7, 8, 46]
		: [extra.channel.ID]

	const top = (await sb.Query.getRecordset(rs => rs
		.select(\"Message_Count AS Total\")
		.select(\"User_Alias.Name AS Name\")
		.from(\"chat_data\", \"Message_Meta_User_Alias\")
		.join(\"chat_data\", \"User_Alias\")
		.where(\"Channel IN %n+\", channels)
		.orderBy(\"Message_Count DESC\")
		.limit(limit)
	));

	return {
		reply: \"Top \" + limit + \" chatters: \" + top.map((i, ind) => \"(#\" + (ind + 1) + \") \" + i.Name + \" - \" + i.Total).join(\", \")
	};
}',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async (extra, limit) => {
	if (!Number.isFinite(Number(limit))) {
		limit = 10;
	}
	if (limit > 10) {
		return { reply: \"Limit set too high!\" };
	}

	const channels = (extra.channel.ID === 7 || extra.channel.ID === 8)
		? [7, 8, 46]
		: [extra.channel.ID]

	const top = (await sb.Query.getRecordset(rs => rs
		.select(\"Message_Count AS Total\")
		.select(\"User_Alias.Name AS Name\")
		.from(\"chat_data\", \"Message_Meta_User_Alias\")
		.join(\"chat_data\", \"User_Alias\")
		.where(\"Channel IN %n+\", channels)
		.orderBy(\"Message_Count DESC\")
		.limit(limit)
	));

	return {
		reply: \"Top \" + limit + \" chatters: \" + top.map((i, ind) => \"(#\" + (ind + 1) + \") \" + i.Name + \" - \" + i.Total).join(\", \")
	};
}'