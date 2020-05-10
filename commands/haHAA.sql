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
		2,
		'haHAA',
		'[\"4Head\", \"4HEad\"]',
		'ping,pipe',
		'Posts a random, hilarious joke, 100% guaranteed.',
		5000,
		NULL,
		NULL,
		'(async function _4head (context) {
	const data = await sb.Got(\"https://icanhazdadjoke.com/\").json();
	return {
		reply: data.joke + \" \" + context.invocation
	};
})',
		'async (prefix) => {
	return [
		\"Posts a random, 100% hilarious dad joke.\",
		\"Guaranteed to make you grimace\",
		\"\",

		`<code>${prefix}4Head</code>`,
		\"(random joke)\"
	];
}'
	)