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
		22,
		'forsenE',
		NULL,
		'forsenE',
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
		'async () => {
	return {
		reply: sb.Utils.randArray(sb.Config.get(\"FORSEN_E\")) + \" forsenE\"
	}
}',
		'No arguments.',
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async () => {
	return {
		reply: sb.Utils.randArray(sb.Config.get(\"FORSEN_E\")) + \" forsenE\"
	}
}'