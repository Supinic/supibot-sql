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
		'mention,opt-out,pipe',
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

	user = user.toLowerCase();

	if (user === context.user.Name || user === \"me\") {
		return {
			reply: \"There are toys made for that, you know...\"
		};
	}
	else if (user === context.platform.Self_Name.toLowerCase()) {
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