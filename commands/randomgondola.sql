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
		171,
		'randomgondola',
		'[\"rgo\"]',
		'ping,pipe',
		'Posts a random gondola video, based on the Gondola Stravers API.',
		20000,
		NULL,
		NULL,
		'(async function randomGondola () {
	const { url } = await sb.Got(\"https://gondola.stravers.net/random\");
	return {
		reply: `nymnH ${url} nymnH`
	};
})',
		NULL
	)