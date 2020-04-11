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
		171,
		'randomgondola',
		'[\"rgo\"]',
		NULL,
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
		0,
		NULL,
		'(async function randomGondola () {
	const { url } = await sb.Got(\"https://gondola.stravers.net/random\");
	return {
		reply: `nymnH ${url} nymnH`
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function randomGondola () {
	const { url } = await sb.Got(\"https://gondola.stravers.net/random\");
	return {
		reply: `nymnH ${url} nymnH`
	};
})'