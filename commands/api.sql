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
		Dynamic_Description
	)
VALUES
	(
		156,
		'api',
		'[\"apidocs\"]',
		'ping,pipe',
		'Posts the link for supinic.com API documentation.',
		10000,
		NULL,
		NULL,
		'(async function api () {
	return {
		reply: \"https://supinic.com/api\"
	}
})',
		NULL
	)