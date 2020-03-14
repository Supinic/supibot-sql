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
		199,
		'stachursky',
		'[\"FeelsStachurskyMan\"]',
		'Posts a random excerpt from a Stachursky song.',
		10000,
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
		'(async function stachursky () {
	return {
		reply: sb.Utils.randArray(sb.Config.get(\"STACHURSKY_QUOTES\"))
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function stachursky () {
	return {
		reply: sb.Utils.randArray(sb.Config.get(\"STACHURSKY_QUOTES\"))
	};
})'