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
		100,
		'activity',
		NULL,
		'mention,pipe,skip-banphrase,whitelist',
		'Posts a link to the supinic website showing the current channel activity.',
		15000,
		'Only available on Twitch (for now)!',
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
		NULL,
		'supinic/supibot-sql'
	)