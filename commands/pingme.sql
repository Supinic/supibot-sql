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
		98,
		'pingme',
		NULL,
		'Sets a self-notification in the current channel when the target user is spotted in a different channel.',
		15000,
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
		'(async function pingMe (context, user) {
	if (!user) {
		return { reply: \"No user provided!\" };
	}

	const targetUser = await sb.User.get(user, true);
	if (!targetUser) {
		return { reply: \"Target user does not exist!\" };
	}
	else if (targetUser.ID === context.user.ID) {
		return { reply: \"You cannot ping yourself when you next type in chat FeelsDankMan !!\" };
	}

	let resultID = null;
	try {
		resultID = await sb.Reminder.create({
			Channel: context.channel?.ID || null,
			User_From: context.user.ID,
			User_To: targetUser.ID,
			Text: null,
			Schedule: null,
			Created: new sb.Date(),
			Private_Message: Boolean(context.privateMessage),
			Platform: context.platform.ID
		});
	}
	catch (e) {
		if (e instanceof sb.Error) {	
			return { reply: e.message };
		}
		else {
			throw e;
		}
	}

	return {
		reply: \"I will ping you when they type in chat (ID \" + resultID + \")\"
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function pingMe (context, user) {
	if (!user) {
		return { reply: \"No user provided!\" };
	}

	const targetUser = await sb.User.get(user, true);
	if (!targetUser) {
		return { reply: \"Target user does not exist!\" };
	}
	else if (targetUser.ID === context.user.ID) {
		return { reply: \"You cannot ping yourself when you next type in chat FeelsDankMan !!\" };
	}

	let resultID = null;
	try {
		resultID = await sb.Reminder.create({
			Channel: context.channel?.ID || null,
			User_From: context.user.ID,
			User_To: targetUser.ID,
			Text: null,
			Schedule: null,
			Created: new sb.Date(),
			Private_Message: Boolean(context.privateMessage),
			Platform: context.platform.ID
		});
	}
	catch (e) {
		if (e instanceof sb.Error) {	
			return { reply: e.message };
		}
		else {
			throw e;
		}
	}

	return {
		reply: \"I will ping you when they type in chat (ID \" + resultID + \")\"
	};
})'