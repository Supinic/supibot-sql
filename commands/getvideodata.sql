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
		129,
		'getvideodata',
		'[\"gvd\"]',
		NULL,
		'Uses supinic\'s API to fetch general info about a link, which is then posted to a Pastebin post.',
		5000,
		0,
		1,
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
		'(async function getVideoData (context, link) {
	let data = null;
	try {
		data = await sb.Utils.linkParser.fetchData(link);
	}
	catch (e) {
		return { reply: \"Unable to parse link.\" };
	}

	if (!data) {
		return { reply: \"Link has been deleted or is otherwise not available.\" };
	}
	else {
		const link = await sb.Pastebin.post(JSON.stringify(data, null, 4), {
			name: data.name + \", requested by \" + context.user.Name,
			format: \"json\"
		});

		return { reply: link };
	}
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function getVideoData (context, link) {
	let data = null;
	try {
		data = await sb.Utils.linkParser.fetchData(link);
	}
	catch (e) {
		return { reply: \"Unable to parse link.\" };
	}

	if (!data) {
		return { reply: \"Link has been deleted or is otherwise not available.\" };
	}
	else {
		const link = await sb.Pastebin.post(JSON.stringify(data, null, 4), {
			name: data.name + \", requested by \" + context.user.Name,
			format: \"json\"
		});

		return { reply: link };
	}
})'