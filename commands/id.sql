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
		Static_Data,
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
		NULL,
		'(async function id (context, user) {
	let targetUser = null;
	if (user) {
		targetUser = await sb.Utils.getDiscordUserDataFromMentions(user, context.append) || await sb.User.get(user, true);
	}
	else {
		targetUser = context.user;
	}

	if (!targetUser) {
		return { reply: \"No data for given user name!\" };
	}

	const [idString, pronoun] = (targetUser.ID === context.user.ID)
		? [\"Your ID is \", \"you\"]
		: [\"That person\'s ID is \", \"they\"];

	const temporalReply = (targetUser.ID === sb.Config.get(\"SELF_ID\"))
		? \"first brought to life as an mIRC bot\"
		: (targetUser.ID < sb.Config.get(\"SELF_ID\"))
			? \"first mentioned in logs (predating Supibot)\"
			: \"first seen by the bot\";

	const delta = sb.Utils.timeDelta(targetUser.Started_Using);
	const now = new sb.Date();
	const { year, month, day } = new sb.Date(targetUser.Started_Using);

	let birthdayString = \"\";
	if (now.year > year && now.month === month && now.day === day) {
		if (targetUser.ID === sb.Config.get(\"SELF_ID\")) {
			birthdayString = \"It\'s my birthday! FeelsBirthdayMan MrDestructoid\";
		}
		else {
			birthdayString = `It\'s your account\'s ${now.year - year}. anniversary in my database! FeelsBirthdayMan Clap`;
		}
	}

	return {
		reply: `${idString} ${targetUser.ID} and ${pronoun} were ${temporalReply} ${delta}. ${birthdayString}`
	};
})',
		'$id => Posts your ID in supibot\'s user database.
$id <user> => Posts their ID in supibot\'s user database.',
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function id (context, user) {
	let targetUser = null;
	if (user) {
		targetUser = await sb.Utils.getDiscordUserDataFromMentions(user, context.append) || await sb.User.get(user, true);
	}
	else {
		targetUser = context.user;
	}

	if (!targetUser) {
		return { reply: \"No data for given user name!\" };
	}

	const [idString, pronoun] = (targetUser.ID === context.user.ID)
		? [\"Your ID is \", \"you\"]
		: [\"That person\'s ID is \", \"they\"];

	const temporalReply = (targetUser.ID === sb.Config.get(\"SELF_ID\"))
		? \"first brought to life as an mIRC bot\"
		: (targetUser.ID < sb.Config.get(\"SELF_ID\"))
			? \"first mentioned in logs (predating Supibot)\"
			: \"first seen by the bot\";

	const delta = sb.Utils.timeDelta(targetUser.Started_Using);
	const now = new sb.Date();
	const { year, month, day } = new sb.Date(targetUser.Started_Using);

	let birthdayString = \"\";
	if (now.year > year && now.month === month && now.day === day) {
		if (targetUser.ID === sb.Config.get(\"SELF_ID\")) {
			birthdayString = \"It\'s my birthday! FeelsBirthdayMan MrDestructoid\";
		}
		else {
			birthdayString = `It\'s your account\'s ${now.year - year}. anniversary in my database! FeelsBirthdayMan Clap`;
		}
	}

	return {
		reply: `${idString} ${targetUser.ID} and ${pronoun} were ${temporalReply} ${delta}. ${birthdayString}`
	};
})'