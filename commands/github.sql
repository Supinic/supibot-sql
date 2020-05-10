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
		162,
		'github',
		NULL,
		'ping,pipe',
		'Posts the supibot GitHub link.',
		5000,
		NULL,
		NULL,
		'(async function github () { 
	return {
		reply: \"Supibot: https://github.com/Supinic/supibot - Website: https://github.com/Supinic/supinic.com\"
	};
})',
		NULL
	)