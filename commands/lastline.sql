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
		43,
		'lastline',
		'[\"ll\", \"lastmessage\", \"lm\"]',
		NULL,
		'Posts the target user\'s last chat line in the context of the current channel, and the date they sent it.',
		5000,
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
		'(async function lastLine (context, user) {
	if (!user) {
		return { reply: \"No user provided!\" };
	}
	else if (!context.channel) {
		return { reply: \"This command is not available in PMs!\" };
	}

	const targetUser = await sb.Utils.getDiscordUserDataFromMentions(user, context.append) || (await sb.User.get(user, true));
	if (!targetUser) {		
		return { reply: \"User not found in the database!\" };
	}

	const userID = targetUser.ID;
	if (userID === context.user.ID) {
		return { reply: \"You\'re right here NaM I can see you\" };
	}

	let data = null;
	if ([7, 8, 46].includes(context.channel.ID)) {
		data = (await sb.Query.getRecordset(rs => rs
			.select(\"Last_Message_Text AS Message\", \"Last_Message_Posted AS Posted\")
			.from(\"chat_data\", \"Message_Meta_User_Alias\")
			.where(\"User_Alias = %n\", userID)
			.where(\"Channel IN (7, 8, 46)\")
			.orderBy(\"Last_Message_Posted DESC\")
		))[0];
	}
	else {
		data = (await sb.Query.getRecordset(rs => rs
			.select(\"Last_Message_Text AS Message\", \"Last_Message_Posted AS Posted\")
			.from(\"chat_data\", \"Message_Meta_User_Alias\")
			.where(\"User_Alias = %n\", userID)
			.where(\"Channel = %n\", context.channel.ID)
		))[0];
	}

	if (!data) {
		return { reply: \"That user has not said anything in this channel!\" };
	}
	else {
		return {
			cooldown: {
				user: null,
				channel: context.channel.ID,
				length: 5000,
			},
			partialReplies: [
				{
					bancheck: false,
					message: \"That user\'s last message in this channel was:\"
				},
				{
					bancheck: true,
					message: data.Message
				},
				{
					bancheck: false,
					message: \"(\" + sb.Utils.timeDelta(data.Posted) + \")\"
				}
			]
		};
	}
})',
		NULL,
		NULL
	)