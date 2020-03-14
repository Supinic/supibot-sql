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
		130,
		'forsenCD',
		'[\"pajaCD\"]',
		'A random quote from the two time! 1993, 1994 back to back blockbuster video game champion!',
		5000,
		0,
		0,
		0,
		0,
		NULL,
		0,
		0,
		0,
		0,
		1,
		0,
		NULL,
		'async (extra) => {
	return {
		reply: sb.Utils.randArray(sb.Config.get(\"FORSEN_CD\")) + \" \" + extra.invocation
	}
}',
		'No arguments.',
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async (extra) => {
	return {
		reply: sb.Utils.randArray(sb.Config.get(\"FORSEN_CD\")) + \" \" + extra.invocation
	}
}'