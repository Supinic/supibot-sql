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
		129,
		'getvideodata',
		'[\"gvd\"]',
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
		'async (extra, link) => {
	const data = JSON.parse(await sb.Utils.request(\"https://supinic.com/api/trackData/fetch?url=\" + link));
	if (data.statusCode === 500) {
		return { reply: \"Unable to parse link.\" };
	}
	else if (data.statusCode === 200) {
		if (data.data) {
			const link = await sb.Pastebin.post(JSON.stringify(data.data, null, 4), { 
				name: data.data.name + \", requested by \" + extra.user.Name,
				format: \"json\"
			});
			return { reply: link };
		}
		else {
			return { reply: \"Link has been deleted or is otherwise not available.\" };
		}
	}
}',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async (extra, link) => {
	const data = JSON.parse(await sb.Utils.request(\"https://supinic.com/api/trackData/fetch?url=\" + link));
	if (data.statusCode === 500) {
		return { reply: \"Unable to parse link.\" };
	}
	else if (data.statusCode === 200) {
		if (data.data) {
			const link = await sb.Pastebin.post(JSON.stringify(data.data, null, 4), { 
				name: data.data.name + \", requested by \" + extra.user.Name,
				format: \"json\"
			});
			return { reply: link };
		}
		else {
			return { reply: \"Link has been deleted or is otherwise not available.\" };
		}
	}
}'