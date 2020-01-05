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
		return {
			reply: \"This command cannot be used outside of channels!\"
		};
	}

	const channelName = context.channel.getDatabaseName();
	const channelID = context.channel.ID;
	let result = null;

	if (context.invocation === \"rq\") {
		user = context.user.Name;
	}
	else if (user) {
		user = user.toLowerCase();
		user = await sb.Utils.getDiscordUserDataFromMentions(user, context.append) || user;
	}

	if (user) {
		const targetUser = await sb.User.get(user, true);
		if (!targetUser) {
			return {
				reply: \"User not found in the database!\"
			};
		}

		if (channelID === 7 || channelID === 8 || channelID === 82) {
			const channels = ((channelID === 82) ? [27, 45, 82] : [7, 8, 46]).map(i => sb.Channel.get(i));
			const counts = (await Promise.all(
				channels.map(channel => sb.Query.getRecordset(rs => rs
					.select(\"IFNULL(Message_Count, 0) AS Messages\")
					.from(\"chat_data\", \"Message_Meta_User_Alias\")
					.where(\"User_Alias = %n\", targetUser.ID)
					.where(\"Channel = %n\", channel.ID)
					.single()
				))
			)).map(i => i?.Messages ?? 0);

			const randomID = sb.Utils.random(1, counts.reduce((prev, cur) => prev += cur, 0));
			let targetID = null;
			let targetChannel = null;

			if (randomID < counts[0]) {
				targetID = randomID;
				targetChannel = channels[0];
			}
			else if (randomID < (counts[0] + counts[1])) {
				targetID = randomID - counts[0];
				targetChannel = channels[1];
			}
			else {
				targetID = randomID - counts[0] - counts[1];
				targetChannel = channels[2];
			}

			const data = await sb.Query.getRecordset(rs => rs
				.select(\"ID\")
				.from(\"chat_line\", targetChannel.getDatabaseName())
				.where(\"User_Alias = %n\", targetUser.ID)
				.limit(1)
				.offset(targetID)
				.single()
			);

			if (!data) {
				return {
					reply: \"That user did not post any lines in any of the relevant channels here!\"
				};
			}

			result = await sb.Query.getRecordset(rs => rs
				.select(\"Text\", \"Posted\", `\"${targetUser.Name}\" AS Name`)
				.from(\"chat_line\", targetChannel.getDatabaseName())
				.where(\"ID = %n\", data.ID)
				.single()
			);
		}
		else {
			const data = (await sb.Query.getRecordset(rs => rs
				.select(\"Message_Count AS Count\")
				.from(\"chat_data\", \"Message_Meta_User_Alias\")
				.where(\"User_Alias = %n\", targetUser.ID)
				.where(\"Channel = %n\", channelID)
				.single()
			));

			if (!data) {
				return {
					reply: \"That user has not posted any messages in this channel!\"
				};
			}
			else if (!data.Count) {
				return {
					reply: \"That user has no metadata associated with them!\"
				};
			}

			const random = await sb.Query.getRecordset(rs => rs
				.select(\"ID\")
				.from(\"chat_line\", channelName)
				.where(\"User_Alias = %n\", targetUser.ID)
				.limit(1)
				.offset(sb.Utils.random(1, data.Count) - 1)
				.single()
			);

			if (!random) {
				return {
					reply: \"No messages could be fetched!\"
				};
			}

			result = await sb.Query.getRecordset(rs => rs
				.select(\"Text\", \"Posted\", `\"${targetUser.Name}\" AS Name`)
				.from(\"chat_line\", channelName)
				.where(\"ID = %n\", random.ID)
				.single()
			);
		}
	}
	else {
		if (channelID === 7 || channelID === 8 || channelID === 82) {
			const channels = ((channelID === 82) ? [27, 45, 82] : [7, 8, 46]).map(i => sb.Channel.get(i).getDatabaseName());
			const counts = (await Promise.all(channels.map(channel =>
				sb.Query.getRecordset(rs => rs
					.select(\"MAX(ID) AS Total\")
					.from(\"chat_line\", channel)
					.single()
				)
			))).map(i => i.Total);

			const ID = sb.Utils.random(1, counts.reduce((acc, cur) => acc += cur, 0));
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
			
			result = await sb.Query.getRecordset(rs => rs
				.select(\"Text\", \"Posted\", \"Name\")
				.from(\"chat_line\", targetChannel)
				.join(\"chat_data\", \"User_Alias\")
				.where(targetChannel + \".ID = %n\", targetID)
				.single()
			);
			
			console.log({result, ID, targetID, targetChannel, channels})
		}
		else {
			const data = await sb.Query.getRecordset(rs => rs
				.select(\"MAX(ID) AS Total\")
				.from(\"chat_line\", channelName)
				.single()
			);

			if (!data || !data.Total) {
				return {
					reply: \"This channel doesn\'t have enough chat lines saved yet!\"
				};
			}

			result = (await sb.Query.getRecordset(rs => rs
				.select(\"Text\", \"Posted\", \"Name\")
				.from(\"chat_line\", channelName)
				.join(\"chat_data\", \"User_Alias\")
				.where(\"`\" + channelName + \"`.ID = %n\", sb.Utils.random(1, data.Total))
				.single()
			));
		}
	}

	return {
		reply: `(${sb.Utils.timeDelta(result.Posted)}) ${result.Name}: ${result.Text}`
	};
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
		return {
			reply: \"This command cannot be used outside of channels!\"
		};
	}

	const channelName = context.channel.getDatabaseName();
	const channelID = context.channel.ID;
	let result = null;

	if (context.invocation === \"rq\") {
		user = context.user.Name;
	}
	else if (user) {
		user = user.toLowerCase();
		user = await sb.Utils.getDiscordUserDataFromMentions(user, context.append) || user;
	}

	if (user) {
		const targetUser = await sb.User.get(user, true);
		if (!targetUser) {
			return {
				reply: \"User not found in the database!\"
			};
		}

		if (channelID === 7 || channelID === 8 || channelID === 82) {
			const channels = ((channelID === 82) ? [27, 45, 82] : [7, 8, 46]).map(i => sb.Channel.get(i));
			const counts = (await Promise.all(
				channels.map(channel => sb.Query.getRecordset(rs => rs
					.select(\"IFNULL(Message_Count, 0) AS Messages\")
					.from(\"chat_data\", \"Message_Meta_User_Alias\")
					.where(\"User_Alias = %n\", targetUser.ID)
					.where(\"Channel = %n\", channel.ID)
					.single()
				))
			)).map(i => i?.Messages ?? 0);

			const randomID = sb.Utils.random(1, counts.reduce((prev, cur) => prev += cur, 0));
			let targetID = null;
			let targetChannel = null;

			if (randomID < counts[0]) {
				targetID = randomID;
				targetChannel = channels[0];
			}
			else if (randomID < (counts[0] + counts[1])) {
				targetID = randomID - counts[0];
				targetChannel = channels[1];
			}
			else {
				targetID = randomID - counts[0] - counts[1];
				targetChannel = channels[2];
			}

			const data = await sb.Query.getRecordset(rs => rs
				.select(\"ID\")
				.from(\"chat_line\", targetChannel.getDatabaseName())
				.where(\"User_Alias = %n\", targetUser.ID)
				.limit(1)
				.offset(targetID)
				.single()
			);

			if (!data) {
				return {
					reply: \"That user did not post any lines in any of the relevant channels here!\"
				};
			}

			result = await sb.Query.getRecordset(rs => rs
				.select(\"Text\", \"Posted\", `\"${targetUser.Name}\" AS Name`)
				.from(\"chat_line\", targetChannel.getDatabaseName())
				.where(\"ID = %n\", data.ID)
				.single()
			);
		}
		else {
			const data = (await sb.Query.getRecordset(rs => rs
				.select(\"Message_Count AS Count\")
				.from(\"chat_data\", \"Message_Meta_User_Alias\")
				.where(\"User_Alias = %n\", targetUser.ID)
				.where(\"Channel = %n\", channelID)
				.single()
			));

			if (!data) {
				return {
					reply: \"That user has not posted any messages in this channel!\"
				};
			}
			else if (!data.Count) {
				return {
					reply: \"That user has no metadata associated with them!\"
				};
			}

			const random = await sb.Query.getRecordset(rs => rs
				.select(\"ID\")
				.from(\"chat_line\", channelName)
				.where(\"User_Alias = %n\", targetUser.ID)
				.limit(1)
				.offset(sb.Utils.random(1, data.Count) - 1)
				.single()
			);

			if (!random) {
				return {
					reply: \"No messages could be fetched!\"
				};
			}

			result = await sb.Query.getRecordset(rs => rs
				.select(\"Text\", \"Posted\", `\"${targetUser.Name}\" AS Name`)
				.from(\"chat_line\", channelName)
				.where(\"ID = %n\", random.ID)
				.single()
			);
		}
	}
	else {
		if (channelID === 7 || channelID === 8 || channelID === 82) {
			const channels = ((channelID === 82) ? [27, 45, 82] : [7, 8, 46]).map(i => sb.Channel.get(i).getDatabaseName());
			const counts = (await Promise.all(channels.map(channel =>
				sb.Query.getRecordset(rs => rs
					.select(\"MAX(ID) AS Total\")
					.from(\"chat_line\", channel)
					.single()
				)
			))).map(i => i.Total);

			const ID = sb.Utils.random(1, counts.reduce((acc, cur) => acc += cur, 0));
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
			
			result = await sb.Query.getRecordset(rs => rs
				.select(\"Text\", \"Posted\", \"Name\")
				.from(\"chat_line\", targetChannel)
				.join(\"chat_data\", \"User_Alias\")
				.where(targetChannel + \".ID = %n\", targetID)
				.single()
			);
			
			console.log({result, ID, targetID, targetChannel, channels})
		}
		else {
			const data = await sb.Query.getRecordset(rs => rs
				.select(\"MAX(ID) AS Total\")
				.from(\"chat_line\", channelName)
				.single()
			);

			if (!data || !data.Total) {
				return {
					reply: \"This channel doesn\'t have enough chat lines saved yet!\"
				};
			}

			result = (await sb.Query.getRecordset(rs => rs
				.select(\"Text\", \"Posted\", \"Name\")
				.from(\"chat_line\", channelName)
				.join(\"chat_data\", \"User_Alias\")
				.where(\"`\" + channelName + \"`.ID = %n\", sb.Utils.random(1, data.Total))
				.single()
			));
		}
	}

	return {
		reply: `(${sb.Utils.timeDelta(result.Posted)}) ${result.Name}: ${result.Text}`
	};
})'