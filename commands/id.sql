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
		19,
		'id',
		NULL,
		'Checks your (or someone else\'s) ID in the database of users - the lower the number, the earlier the user was first spotted',
		10000,
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
		'async (extra, user) => {
	let targetUser = null;
	if (user) {
		targetUser = await sb.Utils.getDiscordUserDataFromMentions(user, extra.append) || await sb.User.get(user, true);
	}
	else {
		targetUser = extra.user;
	}

	if (!targetUser) {
		return { reply: \"No data for given user name!\" };
	}

	const [idString, pronoun] = (targetUser.ID === extra.user.ID) 
		? [\"Your ID is \", \"you\"]
		: [\"That person\'s ID is \", \"they\"];

	const temporalReply = (targetUser.ID === sb.Config.get(\"SELF_ID\"))
		? \"first brought to life as an mIRC bot\"
		: (targetUser.ID < sb.Config.get(\"SELF_ID\"))
			? \"first mentioned in logs (predating Supibot)\"
			: \"first seen by the bot\"

	return {
		 reply: idString + targetUser.ID + \" and \" + pronoun + \" were \" + temporalReply + \" \" + sb.Utils.timeDelta(targetUser.Started_Using) + \".\" 
	};
}',
		'$id => Posts your ID in supibot\'s user database.
$id <user> => Posts their ID in supibot\'s user database.',
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async (extra, user) => {
	let targetUser = null;
	if (user) {
		targetUser = await sb.Utils.getDiscordUserDataFromMentions(user, extra.append) || await sb.User.get(user, true);
	}
	else {
		targetUser = extra.user;
	}

	if (!targetUser) {
		return { reply: \"No data for given user name!\" };
	}

	const [idString, pronoun] = (targetUser.ID === extra.user.ID) 
		? [\"Your ID is \", \"you\"]
		: [\"That person\'s ID is \", \"they\"];

	const temporalReply = (targetUser.ID === sb.Config.get(\"SELF_ID\"))
		? \"first brought to life as an mIRC bot\"
		: (targetUser.ID < sb.Config.get(\"SELF_ID\"))
			? \"first mentioned in logs (predating Supibot)\"
			: \"first seen by the bot\"

	return {
		 reply: idString + targetUser.ID + \" and \" + pronoun + \" were \" + temporalReply + \" \" + sb.Utils.timeDelta(targetUser.Started_Using) + \".\" 
	};
}'