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
		87,
		'wowclassicstatus',
		'[\"wcs\"]',
		NULL,
		'Sets your presumed WoW Classic status - whether or not you\'ll play, and how hard you want to go.',
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
		1,
		NULL,
		'async (extra, ...args) => {
	const msg = args.join(\" \");
	if (!msg) {
		return { reply: \"Check others\' provided status here: supinic.com/wcs\" };
	}

	const escaped = sb.Query.escapeString(msg);
	await sb.Query.raw([
		\"INSERT INTO data.WoW_Classic\",
		\"(User_Alias, Status)\",
		\"VALUES\",
		`(${extra.user.ID}, \"${escaped}\")`,
		`ON DUPLICATE KEY UPDATE Status = \"${escaped}\"` 
	].join(\" \"));

	return { reply: \"Done.\" };
}',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async (extra, ...args) => {
	const msg = args.join(\" \");
	if (!msg) {
		return { reply: \"Check others\' provided status here: supinic.com/wcs\" };
	}

	const escaped = sb.Query.escapeString(msg);
	await sb.Query.raw([
		\"INSERT INTO data.WoW_Classic\",
		\"(User_Alias, Status)\",
		\"VALUES\",
		`(${extra.user.ID}, \"${escaped}\")`,
		`ON DUPLICATE KEY UPDATE Status = \"${escaped}\"` 
	].join(\" \"));

	return { reply: \"Done.\" };
}'