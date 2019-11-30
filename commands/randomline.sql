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
		33,
		'randomline',
		'[\"rl\", \"rq\"]',
		'Fetches a random line from the current channel. If a user is specified, fetches a random line from that user only',
		7500,
		0,
		0,
		0,
		0,
		NULL,
		0,
		1,
		0,
		0,
		1,
		0,
		'(async function randomLine (context, user) {
	if (context.channel === null) {
		return { reply: \"Can\'t use this command here!\" };
	}

	const channelName = context.channel.getDatabaseName();
	const channelID = context.channel.ID;
	let result = null;

	if (user) {
		user = user.toLowerCase();
		user = await sb.Utils.getDiscordUserDataFromMentions(user, context.append) || user;
	}

	if (context.invocation === \"rq\") {
		user = context.user.Name;
	}

	if (user) {
		const targetUser = await sb.User.get(user, true);
		if (!targetUser) {
			return { reply: \"User not found in the database!\" };
		}

		if (channelID === 7 || channelID === 8 || channelID === 82) {
			const channels = ((channelID === 82)
					? [\"nasabot\", \"_core54_1464148741723\", \"240523866026278913\"]
					: [\"cerebot\", \"_trump_nonsub_refuge\", \"150782269382983689\"]
			).map(i => sb.Channel.get(i));

			const counts = (await Promise.all(
				channels.map(channel => sb.Query.getRecordset(rs => rs
					.select(\"IFNULL(Message_Count, 0) AS Messages\")
					.from(\"chat_data\", \"Message_Meta_User_Alias\")
					.where(\"User_Alias = %n\", targetUser.ID)
					.where(\"Channel = %n\", channel.ID)
				))
			)).map(i => (i[0]) ? i[0].Messages : 0);

			const randomID = sb.Utils.random(1, counts.reduce((prev, cur) => prev += cur, 0));
			let targetID = null;
			let targetChannel = null;if (randomID < counts[0]) {
				targetID = randomID;
				targetChannel = channels[0].getDatabaseName();
			}
			else if (randomID < (counts[0] + counts[1])) {
				targetID = randomID - counts[0];
				targetChannel = channels[1].getDatabaseName();
			}
			else {
				targetID = randomID - counts[0] - counts[1];
				targetChannel = channels[2].getDatabaseName();
			}

			const rsID = (await sb.Query.getRecordset(rs => rs
				.select(\"ID\")
				.from(\"chat_line\", targetChannel)
				.where(\"User_Alias = %n\", targetUser.ID)
				.limit(1)
				.offset(targetID)
			))[0];

			if (!rsID) {
				return { reply: \"That user did not post any lines in any of the relevant channels here!\" };
			}

			const ID = rsID.ID;
			result = (await sb.Query.getRecordset(rs => rs
				.select(\"Text\", \"Posted\", `\"${targetUser.Name}\" AS Name`)
				.from(\"chat_line\", targetChannel)
				.where(\"ID = %n\", ID)
			))[0];
		}
		else {
			const count = (await sb.Query.getRecordset(rs => rs
				.select(\"Message_Count\")
				.from(\"chat_data\", \"Message_Meta_User_Alias\")
				.where(\"User_Alias = %n\", targetUser.ID)
				.where(\"Channel = %n\", channelID)
			));

			if (!count[0]) {
				return { reply: \"That user has not posted any messages in this channel!\" };
			}
			else if (!count[0].Message_Count) {
				return { reply: \"That user has no metadata associated with them!\" };
			}

			const random = sb.Utils.random(1, count[0].Message_Count);
			const randomObject = (await sb.Query.getRecordset(rs => rs
				.select(\"ID\")
				.from(\"chat_line\", channelName)
				.where(\"User_Alias = %n\", targetUser.ID)
				.limit(1)
				.offset(random - 1)
			));

			if (!randomObject) {
				return { reply: \"No messages could be fetched\" };
			}

			const ID = randomObject[0].ID;
			result = (await sb.Query.getRecordset(rs => rs
				.select(\"Text\", \"Posted\", `\"${targetUser.Name}\" AS Name`)
				.from(\"chat_line\", channelName)
				.where(\"ID = %n\", ID)
			))[0];
		}
	}
	else {
		if (channelID === 7 || channelID === 8 || channelID === 82) {
			const channels = (channelID === 82)
				? [\"nasabot\", \"_core54_1464148741723\", \"discord_240523866026278913\"]
				: [\"cerebot\", \"_trump_nonsub_refuge\", \"discord_150782269382983689\"];
			const counts = (await Promise.all(
				channels.map(channel => sb.Query.raw(\"SELECT MAX(ID) AS Total FROM `chat_line`.`\" + channel + \"`\"))
			)).map(i => i[0].Total);

			const ID = sb.Utils.random(1, counts.reduce((prev, cur) => prev += cur, 0));
			let targetID = null;
			let targetChannel = null;

			if (ID < counts[0]) {
				targetID = ID;
				targetChannel = channels[0];
			}
			else if (ID < (counts[0] + counts[1])) {
				targetID = ID - counts[0];
				targetChannel = channels[1];
			}
			else {
				targetID = ID - counts[0] - counts[1];
				targetChannel = channels[2];
			}

			result = (await sb.Query.getRecordset(rs => rs
				.select(\"Text\", \"Posted\", \"Name\")
				.from(\"chat_line\", targetChannel)
				.join(\"chat_data\", \"User_Alias\")
				.where(targetChannel + \".ID = %n\", targetID)
			))[0];
		}
		else {
			const maxID = (await sb.Query.raw(\"SELECT MAX(ID) AS MaxID FROM `chat_line`.`\" + channelName + \"`\"))[0].MaxID;
			if (!maxID) {
				return { reply: \"This channel doesn\'t have enough chat lines saved yet!\" };
			}

			result = (await sb.Query.getRecordset(rs => rs
				.select(\"Text\", \"Posted\", \"Name\")
				.from(\"chat_line\", channelName)
				.join(\"chat_data\", \"User_Alias\")
				.where(\"`\" + channelName + \"`.ID = %n\", sb.Utils.random(1, maxID))
				.single()
			));

			if (!result) {
				console.warn({message: \"No result in $rl!\", maxID, context});
			}
		}
	}

	// const aiazymemeDelta = sb.Date.now() - new sb.Date(result.Posted);
	return {
		reply: [
			//\"(\" + aiazymemeDelta + \" milliseconds ago)\",
			\"(\" + sb.Utils.timeDelta(result.Posted) + \")\",
			result.Name + \":\",
			result.Text
		].join(\" \")
	}
})',
		NULL,
		'async (prefix) => [
	\"Fetches a random chat line, in the context of the current channel.\",
	\"If you specify a user, fetches lines from that user only.\",
	\"\",
	prefix + \"rl => random message from anyone\",
	prefix + \"rl [user] => random message from \\\"user\\\"\",
	prefix + \"rq => random message from yourself\"
]'
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function randomLine (context, user) {
	if (context.channel === null) {
		return { reply: \"Can\'t use this command here!\" };
	}

	const channelName = context.channel.getDatabaseName();
	const channelID = context.channel.ID;
	let result = null;

	if (user) {
		user = user.toLowerCase();
		user = await sb.Utils.getDiscordUserDataFromMentions(user, context.append) || user;
	}

	if (context.invocation === \"rq\") {
		user = context.user.Name;
	}

	if (user) {
		const targetUser = await sb.User.get(user, true);
		if (!targetUser) {
			return { reply: \"User not found in the database!\" };
		}

		if (channelID === 7 || channelID === 8 || channelID === 82) {
			const channels = ((channelID === 82)
					? [\"nasabot\", \"_core54_1464148741723\", \"240523866026278913\"]
					: [\"cerebot\", \"_trump_nonsub_refuge\", \"150782269382983689\"]
			).map(i => sb.Channel.get(i));

			const counts = (await Promise.all(
				channels.map(channel => sb.Query.getRecordset(rs => rs
					.select(\"IFNULL(Message_Count, 0) AS Messages\")
					.from(\"chat_data\", \"Message_Meta_User_Alias\")
					.where(\"User_Alias = %n\", targetUser.ID)
					.where(\"Channel = %n\", channel.ID)
				))
			)).map(i => (i[0]) ? i[0].Messages : 0);

			const randomID = sb.Utils.random(1, counts.reduce((prev, cur) => prev += cur, 0));
			let targetID = null;
			let targetChannel = null;if (randomID < counts[0]) {
				targetID = randomID;
				targetChannel = channels[0].getDatabaseName();
			}
			else if (randomID < (counts[0] + counts[1])) {
				targetID = randomID - counts[0];
				targetChannel = channels[1].getDatabaseName();
			}
			else {
				targetID = randomID - counts[0] - counts[1];
				targetChannel = channels[2].getDatabaseName();
			}

			const rsID = (await sb.Query.getRecordset(rs => rs
				.select(\"ID\")
				.from(\"chat_line\", targetChannel)
				.where(\"User_Alias = %n\", targetUser.ID)
				.limit(1)
				.offset(targetID)
			))[0];

			if (!rsID) {
				return { reply: \"That user did not post any lines in any of the relevant channels here!\" };
			}

			const ID = rsID.ID;
			result = (await sb.Query.getRecordset(rs => rs
				.select(\"Text\", \"Posted\", `\"${targetUser.Name}\" AS Name`)
				.from(\"chat_line\", targetChannel)
				.where(\"ID = %n\", ID)
			))[0];
		}
		else {
			const count = (await sb.Query.getRecordset(rs => rs
				.select(\"Message_Count\")
				.from(\"chat_data\", \"Message_Meta_User_Alias\")
				.where(\"User_Alias = %n\", targetUser.ID)
				.where(\"Channel = %n\", channelID)
			));

			if (!count[0]) {
				return { reply: \"That user has not posted any messages in this channel!\" };
			}
			else if (!count[0].Message_Count) {
				return { reply: \"That user has no metadata associated with them!\" };
			}

			const random = sb.Utils.random(1, count[0].Message_Count);
			const randomObject = (await sb.Query.getRecordset(rs => rs
				.select(\"ID\")
				.from(\"chat_line\", channelName)
				.where(\"User_Alias = %n\", targetUser.ID)
				.limit(1)
				.offset(random - 1)
			));

			if (!randomObject) {
				return { reply: \"No messages could be fetched\" };
			}

			const ID = randomObject[0].ID;
			result = (await sb.Query.getRecordset(rs => rs
				.select(\"Text\", \"Posted\", `\"${targetUser.Name}\" AS Name`)
				.from(\"chat_line\", channelName)
				.where(\"ID = %n\", ID)
			))[0];
		}
	}
	else {
		if (channelID === 7 || channelID === 8 || channelID === 82) {
			const channels = (channelID === 82)
				? [\"nasabot\", \"_core54_1464148741723\", \"discord_240523866026278913\"]
				: [\"cerebot\", \"_trump_nonsub_refuge\", \"discord_150782269382983689\"];
			const counts = (await Promise.all(
				channels.map(channel => sb.Query.raw(\"SELECT MAX(ID) AS Total FROM `chat_line`.`\" + channel + \"`\"))
			)).map(i => i[0].Total);

			const ID = sb.Utils.random(1, counts.reduce((prev, cur) => prev += cur, 0));
			let targetID = null;
			let targetChannel = null;

			if (ID < counts[0]) {
				targetID = ID;
				targetChannel = channels[0];
			}
			else if (ID < (counts[0] + counts[1])) {
				targetID = ID - counts[0];
				targetChannel = channels[1];
			}
			else {
				targetID = ID - counts[0] - counts[1];
				targetChannel = channels[2];
			}

			result = (await sb.Query.getRecordset(rs => rs
				.select(\"Text\", \"Posted\", \"Name\")
				.from(\"chat_line\", targetChannel)
				.join(\"chat_data\", \"User_Alias\")
				.where(targetChannel + \".ID = %n\", targetID)
			))[0];
		}
		else {
			const maxID = (await sb.Query.raw(\"SELECT MAX(ID) AS MaxID FROM `chat_line`.`\" + channelName + \"`\"))[0].MaxID;
			if (!maxID) {
				return { reply: \"This channel doesn\'t have enough chat lines saved yet!\" };
			}

			result = (await sb.Query.getRecordset(rs => rs
				.select(\"Text\", \"Posted\", \"Name\")
				.from(\"chat_line\", channelName)
				.join(\"chat_data\", \"User_Alias\")
				.where(\"`\" + channelName + \"`.ID = %n\", sb.Utils.random(1, maxID))
				.single()
			));

			if (!result) {
				console.warn({message: \"No result in $rl!\", maxID, context});
			}
		}
	}

	// const aiazymemeDelta = sb.Date.now() - new sb.Date(result.Posted);
	return {
		reply: [
			//\"(\" + aiazymemeDelta + \" milliseconds ago)\",
			\"(\" + sb.Utils.timeDelta(result.Posted) + \")\",
			result.Name + \":\",
			result.Text
		].join(\" \")
	}
})'