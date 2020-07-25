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
		25,
		'namechange',
		'[\"nc\"]',
		'mention,pipe',
		'Search for the last name change of a given Twitch user.',
		15000,
		NULL,
		NULL,
		'(async function nameChange () {
	return {
		reply: \"Twitch Legal Team has forced CommanderRoot to remove this and many more APIs. https://twitch-tools.rootonline.de/twitch_legal_notice.php\"
	};
})',
		NULL,
		'supinic/supibot-sql'
	)