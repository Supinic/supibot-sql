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
		171,
		'randomgondola',
		'[\"rgo\"]',
		'Posts a random gondola video, based on the Gondola Stravers API.',
		20000,
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
		'(async function randomGondola () {
	const response = await sb.Utils.request({
		url: \"https://gondola.stravers.net/random\",
		useFullResponse: true
	});

	const url = response.request.uri.href;	
	return {
		reply: `nymnH ${url} nymnH`
	}
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function randomGondola () {
	const response = await sb.Utils.request({
		url: \"https://gondola.stravers.net/random\",
		useFullResponse: true
	});

	const url = response.request.uri.href;	
	return {
		reply: `nymnH ${url} nymnH`
	}
})'