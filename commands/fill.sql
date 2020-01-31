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
		175,
		'fill',
		NULL,
		'Takes the input and scrambles it around randomly.',
		20000,
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
		'(async function fill (context, ...words) {
	if (words.length === 0) {
		return {
			reply: \"At least one word must be provided!\"
		};
	}

	let length = 0;
	const result = [];
	const platform = context.platform.Name.toUpperCase();

	let limit = (context.channel?.Message_Limit ?? sb.Config.get(\"DEFAULT_MSG_LIMIT_\" + platform)) - context.user.Name.length - 3;
	if (context.channel && context.channel.sessionData.live) {
		limit = 150;
	}

	while (length < limit) {
		const randomWord = sb.Utils.randArray(words);
		result.push(randomWord);
		length += randomWord.length + 1;
	}

	let cooldown = {};
	if (context.channel === null) {
		cooldown = { length: 10000 };
	}
	else {
		cooldown = {
			user: null,
			channel: context.channel.ID,
			length: (context.channel.sessionData?.live && !context.append.pipe)
				? 60.0e3 // 1 minute
				: context.command.Cooldown
		};
	}

	return {
		reply: result.slice(0, -1).join(\" \"),
		cooldown
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function fill (context, ...words) {
	if (words.length === 0) {
		return {
			reply: \"At least one word must be provided!\"
		};
	}

	let length = 0;
	const result = [];
	const platform = context.platform.Name.toUpperCase();

	let limit = (context.channel?.Message_Limit ?? sb.Config.get(\"DEFAULT_MSG_LIMIT_\" + platform)) - context.user.Name.length - 3;
	if (context.channel && context.channel.sessionData.live) {
		limit = 150;
	}

	while (length < limit) {
		const randomWord = sb.Utils.randArray(words);
		result.push(randomWord);
		length += randomWord.length + 1;
	}

	let cooldown = {};
	if (context.channel === null) {
		cooldown = { length: 10000 };
	}
	else {
		cooldown = {
			user: null,
			channel: context.channel.ID,
			length: (context.channel.sessionData?.live && !context.append.pipe)
				? 60.0e3 // 1 minute
				: context.command.Cooldown
		};
	}

	return {
		reply: result.slice(0, -1).join(\" \"),
		cooldown
	};
})'