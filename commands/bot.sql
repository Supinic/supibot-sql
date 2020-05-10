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
		194,
		'bot',
		NULL,
		'ping,pipe',
		'Allows broadcasters to set various parameters for the bot in their own channel. Usable anywhere, but only applies to their own channel.',
		2500,
		NULL,
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