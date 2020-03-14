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
		193,
		'randomsadcat',
		'[\"rsc\"]',
		'Posts a random sad cat image SadCat',
		15000,
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
		'(async function randomSadCat () {
	const link = sb.Utils.randArray(sb.Config.get(\"SAD_CAT_LINKS\"));
	return {
		reply: \"SadCat \" + link
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function randomSadCat () {
	const link = sb.Utils.randArray(sb.Config.get(\"SAD_CAT_LINKS\"));
	return {
		reply: \"SadCat \" + link
	};
})'