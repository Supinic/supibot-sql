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
		111,
		'levelchange',
		'[\"lc\"]',
		NULL,
		'Search for the last level change (default, staff, admin, ...) of a given Twitch user.',
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
		0,
		NULL,
		'(async function levelChange () {
	return {
		reply: \"Twitch Legal Team has forced CommanderRoot to remove this and many more APIs. https://twitch-tools.rootonline.de/twitch_legal_notice.php\"
	};
})',
		NULL,
		NULL
	)