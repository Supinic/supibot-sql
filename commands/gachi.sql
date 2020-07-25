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
		97,
		'gachi',
		'[\"gachilist\", \"gl\"]',
		'mention,pipe',
		'Posts the link of gachimuchi list on supinic.com',
		10000,
		NULL,
		NULL,
		'(async function gachiList () { 
	return {
		reply: \"https://supinic.com/track/gachi/list\"
	};
})',
		NULL,
		'supinic/supibot-sql'
	)