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
		Dynamic_Description,
		Source
	)
VALUES
	(
		141,
		'necrodancer',
		NULL,
		'mention,pipe,whitelist',
		'Download an audio file to play with Crypt of the Necrodancer.',
		60000,
		NULL,
		NULL,
		'(async function necrodancer (context, link) {
	if (!link) {
		return {
			reply: \"Guidelines for Necrodancer songs here: https://pastebin.com/K4n151xz\",
			cooldown: 2500
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
	
	await context.channel.send(\"Downloading has started! Please wait...\");
	await sb.Got(url);

	return { reply: \"Downloaded successfully :)\" };
})',
		NULL,
		'supinic/supibot-sql'
	)