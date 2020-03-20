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
		'({
	strings: {
		\"public-incoming\": \"That person has too many public reminders pending!\",
		\"public-outgoing\":  \"You have too many public reminders pending!\",
		\"private-incoming\": \"That person has too many private reminders pending!\",
		\"private-outgoing\": \"You have too many private reminders pending!\"
	}
})',
		'(async function pingMe (context, user) {
	if (!user) {
		return { reply: \"No user provided!\" };
	}

	const targetUser = await sb.User.get(user, true);
	if (!targetUser) {
		return { reply: \"Target user does not exist!\" };
	}
	else if (targetUser.ID === context.user.ID) {
		return { reply: \"That makes no sense FeelsDankMan\" };
	}

	const { success, cause, ID } = await sb.Reminder.create({
		Channel: context.channel?.ID || null,
		User_From: context.user.ID,
		User_To: targetUser.ID,
		Text: null,
		Schedule: null,
		Created: new sb.Date(),
		Private_Message: Boolean(context.privateMessage),
		Platform: context.platform.ID
	});

	if (success && !cause) {
		return {
			reply: \"I will ping you when they type in chat (ID \" + ID + \")\"
		};
	}
	else {
		return {
			reply: this.staticData.strings[cause]
		};
	}
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
		return { reply: \"That makes no sense FeelsDankMan\" };
	}

	const { success, cause, ID } = await sb.Reminder.create({
		Channel: context.channel?.ID || null,
		User_From: context.user.ID,
		User_To: targetUser.ID,
		Text: null,
		Schedule: null,
		Created: new sb.Date(),
		Private_Message: Boolean(context.privateMessage),
		Platform: context.platform.ID
	});

	if (success && !cause) {
		return {
			reply: \"I will ping you when they type in chat (ID \" + ID + \")\"
		};
	}
	else {
		return {
			reply: this.staticData.strings[cause]
		};
	}
})'