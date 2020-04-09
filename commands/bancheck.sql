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
		66,
		'bancheck',
		NULL,
		'Checks if a given message would be banphrased in a given channel. Checks the API banphrase (if it exists for given channel) and then the bot\'s banphrases as well.',
		10000,
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
		'(async function banCheck (context, channel, ...rest) {
	if (!channel) {
		return { reply: \"No channel provided!\" };
	}
	else if (rest.length === 0) {
		return { reply: \"No message provided!\" };
	}

	const message = rest.join(\" \");
	const targetChannel = sb.Channel.get(channel.replace(/^#/, \"\"));
	if (!targetChannel) {
		return {
			reply: \"Invalid channel provided!\"
		};
	}
	else if (context.channel?.ID === targetChannel.ID)  {
		return {
			reply: \"Don\'t you think it\'s a bit silly to bancheck the channel you\'re in? PepeLaugh\"
		};
	}

	if (!targetChannel.Links_Allowed) {
		const linkCheck = message.replace(sb.Config.get(\"LINK_REGEX\"), \"\");
		if (linkCheck !== message) {
			return {
				reply: \"Links are not allowed in that channel, so your message would probably get timed out.\"
			};
		}
	}

	if (targetChannel.Banphrase_API_Type === \"Pajbot\") {
		let data = null
		try {
			data = await sb.Banphrase.executeExternalAPI(
				message,
				targetChannel.Banphrase_API_Type,
				targetChannel.Banphrase_API_URL,
				{ fullResponse: true }
			);
		}
		catch (e) {
			console.warn(e);
			return {
				reply: \"Banphrase API did not respond in time!\"
			};
		}

		if (data.banned) {
			console.warn(data);
			
			const { id, name, phrase, length, permanent, operator, case_sensitive: sensitive } = data.banphrase_data;
			const punishment = (permanent)
				? \"permanent ban\"
				: `${sb.Utils.formatTime(length)} seconds timeout`;

			return {
				reply: `Banphrase ID ${id} - ${name}. ${operator}: \"${phrase}\"; punishment: ${punishment}. Case sensitive: ${sensitive ? \"yes\" : \"no\"}.`
			};
		}
	}

	const { string } = await sb.Banphrase.execute(message, targetChannel);
	if (message === string) {
		return {
			reply: \"That message should be fine.\"
		};
	}
	else {
		return {
			reply: \"That message is most likely going to get timed out, based on my banphrases.\"
		};
	}
})',
		'Argument 1: A Twitch channel, prefixed with \"#\". That channel must have the banphrase API set up.
Other arguments make up the message to be checked.

$bancheck #forsen FeelsWeirdMan
$bancheck #nani waiting room',
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function banCheck (context, channel, ...rest) {
	if (!channel) {
		return { reply: \"No channel provided!\" };
	}
	else if (rest.length === 0) {
		return { reply: \"No message provided!\" };
	}

	const message = rest.join(\" \");
	const targetChannel = sb.Channel.get(channel.replace(/^#/, \"\"));
	if (!targetChannel) {
		return {
			reply: \"Invalid channel provided!\"
		};
	}
	else if (context.channel?.ID === targetChannel.ID)  {
		return {
			reply: \"Don\'t you think it\'s a bit silly to bancheck the channel you\'re in? PepeLaugh\"
		};
	}

	if (!targetChannel.Links_Allowed) {
		const linkCheck = message.replace(sb.Config.get(\"LINK_REGEX\"), \"\");
		if (linkCheck !== message) {
			return {
				reply: \"Links are not allowed in that channel, so your message would probably get timed out.\"
			};
		}
	}

	if (targetChannel.Banphrase_API_Type === \"Pajbot\") {
		let data = null
		try {
			data = await sb.Banphrase.executeExternalAPI(
				message,
				targetChannel.Banphrase_API_Type,
				targetChannel.Banphrase_API_URL,
				{ fullResponse: true }
			);
		}
		catch (e) {
			console.warn(e);
			return {
				reply: \"Banphrase API did not respond in time!\"
			};
		}

		if (data.banned) {
			console.warn(data);
			
			const { id, name, phrase, length, permanent, operator, case_sensitive: sensitive } = data.banphrase_data;
			const punishment = (permanent)
				? \"permanent ban\"
				: `${sb.Utils.formatTime(length)} seconds timeout`;

			return {
				reply: `Banphrase ID ${id} - ${name}. ${operator}: \"${phrase}\"; punishment: ${punishment}. Case sensitive: ${sensitive ? \"yes\" : \"no\"}.`
			};
		}
	}

	const { string } = await sb.Banphrase.execute(message, targetChannel);
	if (message === string) {
		return {
			reply: \"That message should be fine.\"
		};
	}
	else {
		return {
			reply: \"That message is most likely going to get timed out, based on my banphrases.\"
		};
	}
})'