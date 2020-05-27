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
		165,
		'discord',
		NULL,
		'ping,pipe',
		'Posts the link to the current channel\'s Discord(?)',
		15000,
		NULL,
		NULL,
		'(async function discord (context) {
	if (context.privateMessage) {
		return {
			success: false,
			reply: \"There\'s no Discord in whispers...\"
		};
	}

	return {
		reply: (context.channel.Data.discord) ?? \"This channel has no Discord description set up.\"
	}
})',
		NULL,
		'supinic/supibot-sql'
	)