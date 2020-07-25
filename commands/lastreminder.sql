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
		69,
		'lastreminder',
		'[\"lr\"]',
		'mention,pipe',
		'Fetches the last (already used) reminder a target user has set for you.',
		10000,
		NULL,
		NULL,
		'(async function lastReminder (context, user) {
	if (!user) {
		return { reply: \"No user provided!\" };
	}

	const targetUserData = await sb.Utils.getDiscordUserDataFromMentions(user, context.append) || await sb.User.get(user, true);
	if (!targetUserData) {
		return { reply: \"That user does not exist!\" };
	}
	else if (targetUserData.Name === context.platform.Self_Name) {
		return {
			reply: \"I\'m not your god damn calendar. Keep track of shit yourself.\"
		};
	}

	const reminder = await sb.Query.getRecordset(rs => rs
		.select(\"Text\", \"Created\")
		.from(\"chat_data\", \"Reminder\")
		.where(\"User_From = %n\", targetUserData.ID)
		.where(\"User_To = %n\", context.user.ID)
		.where(\"Schedule IS NULL\")
		.where(\"Active = %b\", false)
		.orderBy(\"Created DESC\")
		.limit(1)
		.single()
	);

	if (!reminder) {
		return { reply: \"That user has never set a non-timed reminder for you!\" };
	}
	else {
		const delta = sb.Utils.timeDelta(reminder.Created);
		return {
			reply: sb.Utils.tag.trim `
				Last reminder from ${targetUserData.Name} to you:
				${reminder.Text ?? \"(no message)\"}
				(set ${delta})
			`
		};
	}
})',
		NULL,
		'supinic/supibot-sql'
	)