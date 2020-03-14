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
		52,
		'pajaWTH',
		'[\"obamaWTF\"]',
		'Posts a random Anthony \"Obama Chavez\" Stone quote, mostly from Knaked Knights and the snippets from IWF 2017.',
		5000,
		0,
		0,
		1,
		0,
		NULL,
		0,
		0,
		0,
		1,
		1,
		0,
		NULL,
		'async () => ({
	reply: sb.Utils.randArray(sb.Config.get(\"OBAMA_CHAVEZ_QUOTES\"))
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async () => ({
	reply: sb.Utils.randArray(sb.Config.get(\"OBAMA_CHAVEZ_QUOTES\"))
})'