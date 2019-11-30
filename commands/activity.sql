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
		Code,
		Examples,
		Dynamic_Description
	)
VALUES
	(
		100,
		'activity',
		NULL,
		'Posts a link to the supinic website showing the current channel activity.',
		15000,
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
		'(async function activity (context) {
	if (!context.channel) {
		return {
			reply: \"There is no channel activity available here!\" 
		};
	}

	return {
		reply: \"https://supinic.com/bot/channels/\" + context.channel.Name + \"-\" + context.channel.ID + \"/activity\"
	};
})',
		'No arguments.

$activity',
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function activity (context) {
	if (!context.channel) {
		return {
			reply: \"There is no channel activity available here!\" 
		};
	}

	return {
		reply: \"https://supinic.com/bot/channels/\" + context.channel.Name + \"-\" + context.channel.ID + \"/activity\"
	};
})'