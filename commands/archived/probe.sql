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
		113,
		'probe',
		NULL,
		NULL,
		'Posts all possible data about a user. Admin only inspection',
		0,
		0,
		1,
		1,
		1,
		NULL,
		0,
		0,
		0,
		1,
		1,
		0,
		1,
		NULL,
		'(async function probe (context, targetUser) {
	if (!targetUser) {
		return { reply: \"No user provided!\", meta: { skipCooldown: true } };
	}

	const data = {
		supibot: {},
		twitch: {}
	};

	const userData = await sb.User.get(targetUser, true);
	if (userData) {
		data.supibot.channels = [];
		data.supibot.ID = userData.ID;
		data.supibot.Discord_ID = userData.Discord_ID || null;
		data.supibot.Twitch_ID = userData.Twitch_ID || null;
		data.supibot.firstSeen = userData.Started_Using.sqlDate();

		let totalMessages = 0;
		const activeData = await sb.Query.getRecordset(rs => rs
			.select(\"Last_Message_Posted AS Last_Seen\")
			.select(\"Last_Message_Text AS Text\")
			.select(\"Message_Count AS Messages\")
			.select(\"Channel\")
			.from(\"chat_data\", \"Message_Meta_User_Alias\")
			.where(\"User_Alias = %n\", userData.ID)
			.where(\"Channel IN %n+\", sb.Channel.getJoinableForPlatform(\"twitch\").map(i => i.ID))
			.orderBy(\"Last_Message_Posted DESC\")
		);

		let limit = 5;
		for (const row of activeData) {
			const channelData = sb.Channel.get(row.Channel);
			const firstMessage = await sb.Query.getRecordset(rs => rs
				.select(\"Posted\")
				.from(\"chat_line\", channelData.getDatabaseName())
				.where(\"User_Alias = %n\", userData.ID)
				.orderBy(\"ID ASC\")
				.limit(1)
				.single()
			);

			totalMessages += row.Messages;
			if (limit-- < 0) {
				data.supibot.channels.push({
					channel: channelData.Name,
					count: row.Messages,
					firstSeen: firstMessage.Posted.sqlDateTime(),
					lastSeen: row.Last_Seen.sqlDateTime(),
				});
			}
		}

		data.supibot.totalMessages = totalMessages;
	}
	else {
		data.supibot.error = \"No Supibot data regarding that user found.\";
	}

	try {
		const twitchData = JSON.parse(await sb.Utils.request({
			url:  url,
			headers: {
				Accept: \"application/vnd.twitchtv.v5+json\",
				\"Client-ID\": sb.Config.get(\"TWITCH_CLIENT_ID\")
			}
		}));

		data.twitch.ID = twitchData._id;
		data.twitch.bio = twitchData.bio;
		data.twitch.createdAt = (twitchData.created_at)
			? new sb.Date(twitchData.created_at).sqlDateTime()
			: null;
		data.twitch.lastProfileUpdate = (twitchData.update_at) ?
			new sb.Date(twitchData.update_at).sqlDateTime()
			: null;
	}
	catch {
		data.twitch.error = \"No Twitch data regarding that user found.\";
	}

	if ((userData && userData.Twitch_ID) || data.twitch.ID) {
		data.nameChange = await sb.Command.get(\"namechange\").execute(null, (userData && userData.Twitch_ID) || data.twitch.ID);
	}

	const pastebinLink = await sb.Pastebin.post(JSON.stringify(data, null, 4), {
		name: \"Probe of user \" + targetUser + \" requested by \" + context.user.Name
	});
	sb.Master.clients.twitch.pm(context.user.Name, pastebinLink);

	if (!context.append.privateMessage) {
		return { reply: \"The link has been private messaged to you miniDank\" };
	}
})',
		NULL,
		NULL
	)