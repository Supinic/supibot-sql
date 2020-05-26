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
		41,
		'countline',
		'[\"cl\"]',
		'opt-out,ping,pipe',
		'Fetches the amount of chat line you (or a specified user) have in the current channel.',
		15000,
		NULL,
		NULL,
		'(async function countLine (context, user) {
	if (user) {
		user = await sb.Utils.getDiscordUserDataFromMentions(user, context.append) || await sb.User.get(user, true);
		if (!user) {
			return { 
				reply: \"No such user exists in the database!\"
			};
		}
	}
	else {
		user = context.user;
	}

	let lines = null;
	if ([7, 8, 46].includes(context.channel.ID)) {
		lines = (await sb.Query.getRecordset(rs => rs
			.select(\"SUM(Message_Count) AS Total\")
			.from(\"chat_data\", \"Message_Meta_User_Alias\")
			.where(\"User_Alias = %n\", user.ID)
			.where(\"Channel IN(7, 8, 46)\")
		))[0];
	}
	else {
		lines = (await sb.Query.getRecordset(rs => rs
			.select(\"Message_Count AS Total\")
			.from(\"chat_data\", \"Message_Meta_User_Alias\")
			.where(\"User_Alias = %n\", user.ID)
			.where(\"Channel = %n\", context.channel.ID)
		))[0]
	}
	if (!lines) {
		return {
			reply: \"That user has sent no chat lines in this channel!\"
		};
	}

	const who = (user.ID === context.user.ID) ? \"You have\" : \"That user has\";
	return {
		reply: `${who} sent ${lines.Total} chat lines in this channel so far.`
	};
})',
		NULL,
		'supinic/supibot-sql'
	)