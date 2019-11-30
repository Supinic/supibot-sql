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
		66,
		'bancheck',
		NULL,
		'Checks if a given message would be banphrased (API only!) in given channel.',
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
		'(async function banCheck (context, channel, ...rest) {
	if (!channel) {
		return { reply: \"No channel provided!\" };
	}
	else if (rest.length === 0) {
		return { reply: \"No message provided!\" };
	}

	const message = rest.join(\" \");
	const targetChannel = sb.Channel.get(channel.replace(/^#/, \"\"));

	if (!targetChannel || !targetChannel.Banphrase_API_Type || !targetChannel.Banphrase_API_URL) {
		return { reply: \"Target channel has no banphrase API configured!\" };
	}
	else if (context.channel?.ID === targetChannel.ID)  {
		return { reply: \"Don\'t you think it\'s a bit silly to bancheck the channel you\'re in? PepeLaugh\" };
	}

	if (!targetChannel.Links_Allowed) {
		const linkCheck = message.replace(sb.Config.get(\"LINK_REGEX\"), \"\");
		if (linkCheck !== message) {
			return { reply: \"Links are not allowed in that channel, so it would probably get timed out.\" };
		}
	}

	const check = await sb.Banphrase.executeExternalAPI(
		message, 
		targetChannel.Banphrase_API_Type,
		targetChannel.Banphrase_API_URL
	);

	if (!check) {
		return { reply: \"That message will not get timed out by the banphrase API.\" };
	}
	else {
		// console.log(context.user.Name + \" checked message \'\" + message + \"\' for channel \" + targetChannel.Name);
		console.log(\"bancheck result\", check);
		return { reply: \"The phrase \\\"\" + check + \"\\\" will get you timed out!\" };
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

	if (!targetChannel || !targetChannel.Banphrase_API_Type || !targetChannel.Banphrase_API_URL) {
		return { reply: \"Target channel has no banphrase API configured!\" };
	}
	else if (context.channel?.ID === targetChannel.ID)  {
		return { reply: \"Don\'t you think it\'s a bit silly to bancheck the channel you\'re in? PepeLaugh\" };
	}

	if (!targetChannel.Links_Allowed) {
		const linkCheck = message.replace(sb.Config.get(\"LINK_REGEX\"), \"\");
		if (linkCheck !== message) {
			return { reply: \"Links are not allowed in that channel, so it would probably get timed out.\" };
		}
	}

	const check = await sb.Banphrase.executeExternalAPI(
		message, 
		targetChannel.Banphrase_API_Type,
		targetChannel.Banphrase_API_URL
	);

	if (!check) {
		return { reply: \"That message will not get timed out by the banphrase API.\" };
	}
	else {
		// console.log(context.user.Name + \" checked message \'\" + message + \"\' for channel \" + targetChannel.Name);
		console.log(\"bancheck result\", check);
		return { reply: \"The phrase \\\"\" + check + \"\\\" will get you timed out!\" };
	}
})'