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
		123,
		'videostats',
		NULL,
		'Post the statistics about a given bare video link (means, just the ID and not the entire link) in a given Cytube room.',
		10000,
		0,
		0,
		0,
		1,
		'Video statistics are only available in Cytube rooms.',
		0,
		0,
		0,
		1,
		1,
		0,
		NULL,
		'async (extra, link) => {
	if (!link) {
		return { reply: \"No link provided!\", meta: { skipCooldown: true } };
	}
		
	const playedByData = await sb.Query.getRecordset(rs => rs
		.select(\"COUNT(*) AS Count\")
		.select(\"User_Alias.Name AS Name\")
		.from(\"cytube\", \"Video_Request\")
		.join(\"chat_data\", \"User_Alias\")
		.where(\"Link = %s\", link)
		.where(\"Channel = %n\", extra.channel.ID)
		.orderBy(\"COUNT(*) DESC\")
		.groupBy(\"User_Alias\")
	);
	if (playedByData.length === 0) {
		return { reply: \"Provided link has no data associated with it!\" };
	}
	
	const total = playedByData.reduce((acc, cur) => acc += cur.Count, 0);
	const lastPlayedData = await sb.Query.getRecordset(rs => rs
		.select(\"User_Alias.Name AS Name\")
		.select(\"Posted\")
		.from(\"cytube\", \"Video_Request\")
		.join(\"chat_data\", \"User_Alias\")
		.where(\"Link = %s\", link)
		.where(\"Channel = %n\", extra.channel.ID)
		.orderBy(\"Video_Request.ID DESC\")
		.limit(1)
		.single()
	);
		
	const top5 = [];
	for (let i = 0; i < 5; i++) {
		if (playedByData[i]) {
			top5.push(playedByData[i].Name + \": \" + playedByData[i].Count + \"x\");
		}
		else {
			break;
		}
	}
		
		
	return {
		reply: `That video was queued ${total} times before (mostly by: ${top5.join(\"; \")}). Last time it was queued ${sb.Utils.timeDelta(lastPlayedData.Posted)}, by ${lastPlayedData.Name}`
	};
}',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async (extra, link) => {
	if (!link) {
		return { reply: \"No link provided!\", meta: { skipCooldown: true } };
	}
		
	const playedByData = await sb.Query.getRecordset(rs => rs
		.select(\"COUNT(*) AS Count\")
		.select(\"User_Alias.Name AS Name\")
		.from(\"cytube\", \"Video_Request\")
		.join(\"chat_data\", \"User_Alias\")
		.where(\"Link = %s\", link)
		.where(\"Channel = %n\", extra.channel.ID)
		.orderBy(\"COUNT(*) DESC\")
		.groupBy(\"User_Alias\")
	);
	if (playedByData.length === 0) {
		return { reply: \"Provided link has no data associated with it!\" };
	}
	
	const total = playedByData.reduce((acc, cur) => acc += cur.Count, 0);
	const lastPlayedData = await sb.Query.getRecordset(rs => rs
		.select(\"User_Alias.Name AS Name\")
		.select(\"Posted\")
		.from(\"cytube\", \"Video_Request\")
		.join(\"chat_data\", \"User_Alias\")
		.where(\"Link = %s\", link)
		.where(\"Channel = %n\", extra.channel.ID)
		.orderBy(\"Video_Request.ID DESC\")
		.limit(1)
		.single()
	);
		
	const top5 = [];
	for (let i = 0; i < 5; i++) {
		if (playedByData[i]) {
			top5.push(playedByData[i].Name + \": \" + playedByData[i].Count + \"x\");
		}
		else {
			break;
		}
	}
		
		
	return {
		reply: `That video was queued ${total} times before (mostly by: ${top5.join(\"; \")}). Last time it was queued ${sb.Utils.timeDelta(lastPlayedData.Posted)}, by ${lastPlayedData.Name}`
	};
}'