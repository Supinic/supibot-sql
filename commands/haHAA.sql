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
		2,
		'haHAA',
		'[\"4Head\", \"4HEad\"]',
		NULL,
		'Posts a random, hilarious joke, 100% guaranteed.',
		5000,
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
		'(async function _4head (context) {
	const data = await sb.Got(\"https://icanhazdadjoke.com/\").json();
	return {
		reply: data.joke + \" \" + context.invocation
	};
})',
		NULL,
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