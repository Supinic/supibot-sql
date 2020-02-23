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
		102,
		'accountage',
		'[\"accage\"]',
		'Fetches the Twitch account age of a given account. If none is given, checks yours.',
		15000,
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
		'(async function accountAge (context, user) {
	if (!user) { 
		user = context.user.Name;
	}

	try {
		const searchParams = new sb.URLParams().set(\"login\", user).toString();
		const rawData = await sb.Got.instances.Twitch.V5(\"users\", { searchParams });

		const data = rawData.users[0];
		const delta = sb.Utils.timeDelta(new sb.Date(data.created_at));
		const pronoun = (user.toLowerCase() === context.user.Name)
			? \"Your\"
			: \"That\";

		return { reply: `${pronoun} Twitch account was created ${delta}.` };
	}
	catch (e) {
		console.log(e, e.response);
		return { reply: `That Twitch account has no data associated with them.` };
	}
})',
		'No arguments: Shows your Twitch account\'s username.
If given, the first argument is the username to check.

$accage
$accage supibot',
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function accountAge (context, user) {
	if (!user) { 
		user = context.user.Name;
	}

	try {
		const searchParams = new sb.URLParams().set(\"login\", user).toString();
		const rawData = await sb.Got.instances.Twitch.V5(\"users\", { searchParams });

		const data = rawData.users[0];
		const delta = sb.Utils.timeDelta(new sb.Date(data.created_at));
		const pronoun = (user.toLowerCase() === context.user.Name)
			? \"Your\"
			: \"That\";

		return { reply: `${pronoun} Twitch account was created ${delta}.` };
	}
	catch (e) {
		console.log(e, e.response);
		return { reply: `That Twitch account has no data associated with them.` };
	}
})'