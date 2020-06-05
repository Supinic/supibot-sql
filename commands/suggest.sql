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
		48,
		'suggest',
		'[\"suggestions\"]',
		'ping,skip-banphrase',
		'Suggest a feature for Supinic, regarding Supibot, Discord/Cytube, or the website. Posts links to a suggestion list if you don\'t provide any text.',
		60000,
		NULL,
		NULL,
		'(async function suggest (context, ...args) {
	if (args.length === 0 || context.invcation === \"suggestions\") {
		return {
			reply: sb.Utils.tag.trim `
				All suggestions: https://supinic.com/bot/suggestions/list
				||
				Your suggestions: https://supinic.com/bot/suggestions/list?columnName=${context.user.Name}
			`,
			cooldown: 5000
		};
	}

	const row = await sb.Query.getRow(\"data\", \"Suggestion\")
	row.setValues({
		Text: args.join(\" \"),
		User_Alias: context.user.ID,
		Priority: 255
	});

	await row.save();

	const emote = (context.platform.Name === \"twitch\")
		? \"BroBalt\"
		: \"👍\";

	return {
		reply: `Suggestion saved, and will eventually be processed (ID ${row.values.ID}) ${emote}`
	};
})',
		NULL,
		'supinic/supibot-sql'
	)