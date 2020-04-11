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
		192,
		'fuck',
		NULL,
		NULL,
		'Fucks target user to bed.',
		10000,
		0,
		0,
		0,
		0,
		NULL,
		0,
		1,
		0,
		1,
		1,
		0,
		0,
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
	else if (user === sb.Config.get(\"SELF\")) {
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
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function fuck (context, user, emote) {
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
	else if (user === sb.Config.get(\"SELF\")) {
		return {
			reply: \"Hey buddy, I think you got the wrong door.\"
		};
	}
	else {
		return {
			reply: `You ${randomString} fucked ${user}\'s brains out ${emote || \"gachiGASM\"}`
		};
	}
})'