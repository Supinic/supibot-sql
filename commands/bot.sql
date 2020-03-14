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
		194,
		'bot',
		NULL,
		'Allows broadcasters to set various parameters for the bot in their own channel. Usable anywhere, but only applies to their own channel.',
		2500,
		0,
		0,
		0,
		0,
		NULL,
		0,
		0,
		0,
		1,
		1,
		0,
		NULL,
		'(async function bot (context, command, user) {
	if (!command) {
		return {
			reply: \"No command provided! Use enable/disable, or read the extended help!\"
		};
	}

	user = (user) 
		? await sb.User.get(user, true)
		: context.user;

	if (!user) {
		return {
			reply: \"Invalid user provided!\"
		};
	}

	if (!context.user.Data.bypassOptOuts && (user !== context.user || !sb.Channel.get(user.Name))) {
		return {
			reply: \"Combination of user and channel is invalid!\"
		};
	}

	const channel = sb.Channel.get(user.Name);
	const prefix = sb.Config.get(\"COMMAND_PREFIX\");
	command = command.toLowerCase();

	switch (command) {
		case \"disable\":
			if (channel.Mode === \"Read\") {
				return {
					reply: \"Channel is already set to read-only!\"
				};
			}

			setTimeout(() => channel.Mode = \"Read\", 5000);
			return {
				reply: `Channel set to read-only mode in 5 seconds. Use \"${prefix}${this.Name}\" enable in a different channel to re-enable.`
			};

		case \"enable\":
			if (channel.Mode !== \"Read\") {
				return {
					reply: \"Channel is already set to write!\"
				};
			}

			channel.Mode = \"Write\";
			return {
				reply: \"Channel mode reset back to write.\"
			};

		default: return {
			reply: \"Invalid command provided!\"
		}
	}
})
',
		NULL,
		'async (prefix) => {

	return [
		\"Currently, you can enable or disable the bot in your channel.\",
		\"After disabling, you can enable it again in a different channel. I recommend @supibot - that one is always active.\",
		\"\",

		`<code>${prefix}bot disable</code>`,
		\"Disables the bot in your channel indefinitely\",
		\"\",

		`<code>${prefix}bot enable supinic</code>`,
		\"Re-enables the bot in channel <u>supinic</u>\",
	];
}'
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function bot (context, command, user) {
	if (!command) {
		return {
			reply: \"No command provided! Use enable/disable, or read the extended help!\"
		};
	}

	user = (user) 
		? await sb.User.get(user, true)
		: context.user;

	if (!user) {
		return {
			reply: \"Invalid user provided!\"
		};
	}

	if (!context.user.Data.bypassOptOuts && (user !== context.user || !sb.Channel.get(user.Name))) {
		return {
			reply: \"Combination of user and channel is invalid!\"
		};
	}

	const channel = sb.Channel.get(user.Name);
	const prefix = sb.Config.get(\"COMMAND_PREFIX\");
	command = command.toLowerCase();

	switch (command) {
		case \"disable\":
			if (channel.Mode === \"Read\") {
				return {
					reply: \"Channel is already set to read-only!\"
				};
			}

			setTimeout(() => channel.Mode = \"Read\", 5000);
			return {
				reply: `Channel set to read-only mode in 5 seconds. Use \"${prefix}${this.Name}\" enable in a different channel to re-enable.`
			};

		case \"enable\":
			if (channel.Mode !== \"Read\") {
				return {
					reply: \"Channel is already set to write!\"
				};
			}

			channel.Mode = \"Write\";
			return {
				reply: \"Channel mode reset back to write.\"
			};

		default: return {
			reply: \"Invalid command provided!\"
		}
	}
})
'