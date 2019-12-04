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
		48,
		'suggest',
		NULL,
		'Suggest a feature for Supinic, regarding Supibot, Discord/Cytube, or the website',
		60000,
		0,
		0,
		1,
		0,
		NULL,
		0,
		0,
		0,
		1,
		0,
		0,
		'(async function suggest (context, ...args) {
	if (args.length === 0) {
		return { 
			reply: \"All suggestions: https://supinic.com/bot/suggestions/list || Your suggestions (requires login): https://supinic.com/bot/suggestions/mine || Statistics (requires login): https://supinic.com/bot/suggestions/stats\"
		};
	}

	const row = await sb.Query.getRow(\"data\", \"Suggestion\")
	row.setValues({
		Text: args.join(\" \"),
		User_Alias: context.user.ID
	});
	await row.save();

	return { 
		reply: \"Suggestion saved, and will eventually be processed (ID \" + row.values.ID + \")\"
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function suggest (context, ...args) {
	if (args.length === 0) {
		return { 
			reply: \"All suggestions: https://supinic.com/bot/suggestions/list || Your suggestions (requires login): https://supinic.com/bot/suggestions/mine || Statistics (requires login): https://supinic.com/bot/suggestions/stats\"
		};
	}

	const row = await sb.Query.getRow(\"data\", \"Suggestion\")
	row.setValues({
		Text: args.join(\" \"),
		User_Alias: context.user.ID
	});
	await row.save();

	return { 
		reply: \"Suggestion saved, and will eventually be processed (ID \" + row.values.ID + \")\"
	};
})'