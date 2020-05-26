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
		Dynamic_Description,
		Source
	)
VALUES
	(
		102,
		'accountage',
		'[\"accage\"]',
		'ping,pipe',
		'Fetches the Twitch account age of a given account. If none is given, checks yours.',
		15000,
		NULL,
		NULL,
		'(async function accountAge (context, user) {
	if (!user) {
		user = context.user.Name;
	}

	const rawData = await sb.Got.instances.Twitch.V5({
		url: \"users\",
		throwHttpErrors: false,
		searchParams: new sb.URLParams()
			.set(\"login\", user)
			.toString()
	});

	const data = rawData.users[0];
	if (!data) {
		return {
			reply: \"That Twitch account has no data associated with them.\"
		};
	}

	const now = new sb.Date();
	const created = new sb.Date(data.created_at);
	const delta = sb.Utils.timeDelta(created);
	const pronoun = (user.toLowerCase() === context.user.Name)
		? \"Your\"
		: \"That\";

	let anniversary = \"\";
	if (now.year > created.year && now.month === created.month && now.day === created.day) {
		const who = (user.ID === sb.Config.get(\"SELF_ID\")) ? \"my\" : \"your\";
		anniversary = `It\'s ${who} ${now.year - created.year}. Twitch anniversary! FeelsBirthdayMan Clap`;
	}

	return {
		reply: `${pronoun} Twitch account was created ${delta}. ${anniversary}`
	};
})',
		NULL,
		'supinic/supibot-sql'
	)