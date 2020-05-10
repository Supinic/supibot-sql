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
		Dynamic_Description
	)
VALUES
	(
		69,
		'lastreminder',
		'[\"lr\"]',
		'ping,pipe',
		'Fetches the last (already used) reminder a target user has set for you.',
		10000,
		NULL,
		NULL,
		'async (extra, user) => {
	if (!user) {
		return { reply: \"No user provided!\" };
	}
	
	const targetUserData = await sb.Utils.getDiscordUserDataFromMentions(user, extra.append) || await sb.User.get(user, true);
	if (!targetUserData) {
		return { reply: \"That user does not exist!\" };
	}
	else if (targetUserData.ID === sb.Config.get(\"SELF_ID\")) {
		return { reply: \"I\'m not your god damn calendar. Keep track of shit yourself.\" };
	}
	
	const reminderData = (await sb.Query.getRecordset(rs => rs
		.select(\"Text\", \"Created\")
		.from(\"chat_data\", \"Reminder\")
		.where(\"User_From = %n\", targetUserData.ID)
		.where(\"User_To = %n\", extra.user.ID)
		.where(\"Schedule IS NULL\")
		.where(\"Active = %b\", false)
		.orderBy(\"Created DESC\")
		.limit(1)
	))[0];
	
	if (!reminderData) {
		return { reply: \"That user has never set a non-timed reminder for you!\" };
	}
	else {
		return { 
			reply: [
				\"Last reminder from\",
				targetUserData.Name,
				\"to you:\",
				reminderData.Text || \"(no message)\",
				\"(set \" + sb.Utils.timeDelta(reminderData.Created) + \")\"
			].join(\" \")
		};
	}	
}',
		NULL
	)