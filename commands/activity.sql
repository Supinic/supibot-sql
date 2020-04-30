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
		100,
		'activity',
		NULL,
		NULL,
		'Posts a link to the supinic website showing the current channel activity.',
		15000,
		0,
		0,
		1,
		1,
		'Only available on Twitch (for now)!',
		0,
		0,
		0,
		1,
		1,
		0,
		0,
		NULL,
		'(async function activity (context, target) {
	const channel = sb.Channel.get(target ?? context.channel, context.platform);
	if (!channel) {
		return {
			success: false,
			reply: \"Channel does not exist or has no activity available!\" 
		};
	}

	return {
		reply: `Check channel\'s recent activity here: https://supinic.com/bot/channel/${channel.ID}/activity`
	};
})',
		'No arguments.

$activity',
		NULL
	)