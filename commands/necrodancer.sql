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
		141,
		'necrodancer',
		NULL,
		'Download an audio file to play with Crypt of the Necrodancer.',
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
		'(async function necrodancer (context, link) {
	if (!link) {
		return {
			reply: \"Guidelines for Necrodancer songs here: https://pastebin.com/K4n151xz\",
			meta: {
				skipCooldown: true
			}
		};
	}

	let data = null;
	try {
		data = await sb.Utils.linkParser.fetchData(link);
	}
	catch {
		return { reply: \"Link is not parsable!\" };
	}

	const name = encodeURIComponent(data.name + \" by \" + context.user.Name);
	const url = `${sb.Config.get(\"LOCAL_IP\")}:${sb.Config.get(\"LOCAL_PLAY_SOUNDS_PORT\")}?necrodancer=${data.link}&name=${name}`;
	
	sb.Master.send(\"Downloading has started! Please wait...\", context.channel);
	await sb.Utils.request(url);

	return { reply: \"Downloaded successfully :)\" };
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function necrodancer (context, link) {
	if (!link) {
		return {
			reply: \"Guidelines for Necrodancer songs here: https://pastebin.com/K4n151xz\",
			meta: {
				skipCooldown: true
			}
		};
	}

	let data = null;
	try {
		data = await sb.Utils.linkParser.fetchData(link);
	}
	catch {
		return { reply: \"Link is not parsable!\" };
	}

	const name = encodeURIComponent(data.name + \" by \" + context.user.Name);
	const url = `${sb.Config.get(\"LOCAL_IP\")}:${sb.Config.get(\"LOCAL_PLAY_SOUNDS_PORT\")}?necrodancer=${data.link}&name=${name}`;
	
	sb.Master.send(\"Downloading has started! Please wait...\", context.channel);
	await sb.Utils.request(url);

	return { reply: \"Downloaded successfully :)\" };
})'