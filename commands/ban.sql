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
		54,
		'ban',
		'[\"unban\"]',
		NULL,
		'Bans/unbans any combination of channel, user, and command from being executed. Only usable by administrators, or Twitch channel owners.',
		5000,
		0,
		1,
		1,
		0,
		NULL,
		0,
		0,
		0,
		1,
		0,
		1,
		0,
		NULL,
		'(async function ban (context, ...args) {
	if (context.platform.Name !== \"twitch\") {
		return {
			success: false,
			reply: \"Not available outside of Twitch!\"
		};
	}

	/** @type {string|null} */
	let level = null;
	if (context.user.Data.administrator) {
		level = \"administrator\";
	}
	else if (context.channel.isUserChannelOwner(context.user)) {
		level = \"channel-owner\";
	}

	if (level === null) {
		return {
			success: false,
			reply: \"Must be an adminstrator or channel owner!\"
		};
	}

	const { invocation } = context;
	const options = {
		Channel: (level === \"channel-owner\") ? context.channel.ID : null,
		User_Alias: null,
		Command: null,
		Type: \"Blacklist\",
		Response: \"None\",
		Reason: null,
		Issued_By: context.user.ID
	};

	if (level === \"channel-owner\") {
		options.Response = \"Reason\";
		options.Reason = \"Banned by channel owner.\";
	}

	for (let i = 0; i < args.length; i++) {
		const token = args[i];
		const value = token.split(\":\")[1];

		if (token.includes(\"channel:\")) {
			if (level === \"admin\") {
				const channelData = sb.Channel.get(value);
				if (!channelData) {
					return {
						success: false,
						reply: \"Channel was not found!\"
					};
				}

				options.Channel = channelData.ID;
			}
			else {
				return {
					success: false,
					reply: `You cannot ${invocation} outside of your channel!`
				};
			}
		}
		else if (token.includes(\"command:\")) {
			const commandData = sb.Command.get(value);
			if (!commandData) {
				return {
					success: false,
					reply: \"Channel was not found!\"
				};
			}
			else if (commandData === this) {
				return {
					success: false,
					reply: \"Come on now... PepeLaugh\"
				};
			}

			options.Command = commandData.ID;
		}
		else if (token.includes(\"user:\")) {
			const userData = await sb.User.get(value);
			if (!userData) {
				return {
					success: false,
					reply: \"User was not found!\"
				};
			}
			else if (userData === context.user) {
				return {
					success: false,
					reply: \"Come on now... PepeLaugh\"
				};
			}

			options.User_Alias = userData.ID;
		}
	}

	if (!options.Channel && !options.User_Alias && !options.Command) {
		return {
			success: false,
			reply: \"Not enough data provided to create a ban!\"
		};
	}

	const existing = sb.Filter.data.find(i =>
		i.Channel === options.Channel
		&& i.Command === options.Command
		&& i.User_Alias === options.User_Alias
	);

	if (existing) {
		if (existing.Issued_By !== context.user.ID && level !== \"administrator\") {
			return {
				success: false,
				reply: \"This ban has not been created by you, so you cannot modify it!\"
			};
		}
		else if ((existing.Active && invocation === \"ban\") || (!existing.Active && invocation === \"unban\")) {
			return {
				success: false,
				reply: `That combination is already ${invocation}ned!`
			};
		}

		await existing.toggle();

		const [prefix, suffix] = (existing.Active) ? [\"\", \" again\"] : [\"un\", \"\"];
		return {
			reply: `Succesfully ${prefix}banned${suffix}.`
		};
	}
	else {
		if (invocation === \"unban\") {
			return {
				success: false,
				reply: \"This combination has not been banned yet, so it cannot be unbanned!\"
			};
		}

		const ban = await sb.Filter.create(options);
		return {
			reply: `Succesfully banned (ID ${ban.ID})`
		};
	}
})',
		NULL,
		'async (prefix) => {
	return [
		\"Bans or unbans any combination of user/channel/command.\",
		\"Only usable by admins or Twitch channel owners. Channel owners can only ban combinations in their channel.\",
		\"All following examples assume the command is executed by a channel owner.\",
		\"\",

		`<code>${prefix}ban user:test command:rl</code>`,
		\"Bans user <b>test</b> from executing the command <b>rl</b> in the current channel.\",
		\"\",

		`<code>${prefix}ban command:rl</code>`,
		\"Bans everyone from executing the command <b>rl</b> in the current channel.\",
		\"\",

		`<code>${prefix}ban user:test</code>`,
		\"Bans user <b>test</b> from executing any commands in the current channel.\",
		\"\",

		\"---\",
		\"\",

		`<code>${prefix}unban user:test command:rl</code>`,
		\"If banned before, user <b>test</b> will be unbanned from executing the command <b>rl</b> in the current channel.\",
		\"\",

		`<code>${prefix}unban command:rl</code>`,
		\"If banned before, everyone will be unbanned from executing the command <b>rl</b> in the current channel.\",
		\"\",

		`<code>${prefix}unban user:test</code>`,
		\"If banned before, user <b>test</b> will be unbanned from executing anu commands in the current channel.\"
	];
}'
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function ban (context, ...args) {
	if (context.platform.Name !== \"twitch\") {
		return {
			success: false,
			reply: \"Not available outside of Twitch!\"
		};
	}

	/** @type {string|null} */
	let level = null;
	if (context.user.Data.administrator) {
		level = \"administrator\";
	}
	else if (context.channel.isUserChannelOwner(context.user)) {
		level = \"channel-owner\";
	}

	if (level === null) {
		return {
			success: false,
			reply: \"Must be an adminstrator or channel owner!\"
		};
	}

	const { invocation } = context;
	const options = {
		Channel: (level === \"channel-owner\") ? context.channel.ID : null,
		User_Alias: null,
		Command: null,
		Type: \"Blacklist\",
		Response: \"None\",
		Reason: null,
		Issued_By: context.user.ID
	};

	if (level === \"channel-owner\") {
		options.Response = \"Reason\";
		options.Reason = \"Banned by channel owner.\";
	}

	for (let i = 0; i < args.length; i++) {
		const token = args[i];
		const value = token.split(\":\")[1];

		if (token.includes(\"channel:\")) {
			if (level === \"admin\") {
				const channelData = sb.Channel.get(value);
				if (!channelData) {
					return {
						success: false,
						reply: \"Channel was not found!\"
					};
				}

				options.Channel = channelData.ID;
			}
			else {
				return {
					success: false,
					reply: `You cannot ${invocation} outside of your channel!`
				};
			}
		}
		else if (token.includes(\"command:\")) {
			const commandData = sb.Command.get(value);
			if (!commandData) {
				return {
					success: false,
					reply: \"Channel was not found!\"
				};
			}
			else if (commandData === this) {
				return {
					success: false,
					reply: \"Come on now... PepeLaugh\"
				};
			}

			options.Command = commandData.ID;
		}
		else if (token.includes(\"user:\")) {
			const userData = await sb.User.get(value);
			if (!userData) {
				return {
					success: false,
					reply: \"User was not found!\"
				};
			}
			else if (userData === context.user) {
				return {
					success: false,
					reply: \"Come on now... PepeLaugh\"
				};
			}

			options.User_Alias = userData.ID;
		}
	}

	if (!options.Channel && !options.User_Alias && !options.Command) {
		return {
			success: false,
			reply: \"Not enough data provided to create a ban!\"
		};
	}

	const existing = sb.Filter.data.find(i =>
		i.Channel === options.Channel
		&& i.Command === options.Command
		&& i.User_Alias === options.User_Alias
	);

	if (existing) {
		if (existing.Issued_By !== context.user.ID && level !== \"administrator\") {
			return {
				success: false,
				reply: \"This ban has not been created by you, so you cannot modify it!\"
			};
		}
		else if ((existing.Active && invocation === \"ban\") || (!existing.Active && invocation === \"unban\")) {
			return {
				success: false,
				reply: `That combination is already ${invocation}ned!`
			};
		}

		await existing.toggle();

		const [prefix, suffix] = (existing.Active) ? [\"\", \" again\"] : [\"un\", \"\"];
		return {
			reply: `Succesfully ${prefix}banned${suffix}.`
		};
	}
	else {
		if (invocation === \"unban\") {
			return {
				success: false,
				reply: \"This combination has not been banned yet, so it cannot be unbanned!\"
			};
		}

		const ban = await sb.Filter.create(options);
		return {
			reply: `Succesfully banned (ID ${ban.ID})`
		};
	}
})'