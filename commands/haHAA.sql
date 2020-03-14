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
		\"Posts a random 100% hilarious dad joke.\",
		\"No arguments.\",
		\"\",
		prefix + \"haHAA => <random joke> haHAA\",
		prefix + \"4Head => <random joke> 4Head\",
		prefix + \"4HEad => <random joke> 4HEad\"
	];
}'
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function _4head (context) {
	const data = await sb.Got(\"https://icanhazdadjoke.com/\").json();
	return {
		reply: data.joke + \" \" + context.invocation
	};
})'