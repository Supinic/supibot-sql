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
		178,
		'cytube',
		NULL,
		'mention,pipe,whitelist',
		'Posts the link to channel\'s cytube',
		15000,
		NULL,
		NULL,
		'(async function cytube () {
	return {
		reply: \"Check it out here: https://cytu.be/r/forsenoffline\"
	};
})',
		NULL,
		'supinic/supibot-sql'
	)