INSERT INTO
	`chat_data`.`Command`
	(
		ID,
		Name,
		Aliases,
		Flags,
		Description,
		Cooldown,
		Whitelist_Response,
		Static_Data,
		Code,
		Dynamic_Description
	)
VALUES
	(
		129,
		'getvideodata',
		'[\"gvd\"]',
		'ping,pipe,system',
		'Uses supinic\'s API to fetch general info about a link, which is then posted to a Pastebin post.',
		5000,
		NULL,
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
		NULL
	)