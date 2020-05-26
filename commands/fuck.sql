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
		192,
		'fuck',
		NULL,
		'opt-out,ping,pipe',
		'Fucks target user to bed.',
		10000,
		NULL,
		NULL,
		'(async function fuck (context, user, emote) {
	let randomString = \"\";
	if (!user) {
		randomString = \"randomly\";
		user = sb.Utils.randArray([...sb.User.data.values()]).Name;
	}

	if (user === context.user.Name) {
		return {
			reply: \"There are toys made for that, you know...\"
		};
	}
	else if (user === context.platform.Self_Name) {
		return {
			reply: \"Hey buddy, I think you got the wrong door.\"
		};
	}
	else {
		return {
			reply: `You ${randomString} fucked ${user}\'s brains out ${emote || \"gachiGASM\"}`
		};
	}
})',
		NULL,
		'supinic/supibot-sql'
	)