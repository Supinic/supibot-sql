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
		Dynamic_Description,
		Source
	)
VALUES
	(
		87,
		'wowclassicstatus',
		'[\"wcs\"]',
		'archived,mention,pipe,skip-banphrase',
		'Sets your presumed WoW Classic status - whether or not you\'ll play, and how hard you want to go.',
		5000,
		NULL,
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
		'supinic/supibot-sql'
	)