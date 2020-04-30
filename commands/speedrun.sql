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
		12,
		'speedrun',
		'[\"gdq\"]',
		NULL,
		'Posts a Markov chain-generated GDQ speedrun donation message.',
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
		0,
		NULL,
		'(async function speedrun () {
	const { comment } = await sb.Got.instances.Leppunen(\"gdq\").json();
	return {
		reply: comment
	};

	// const model = await sb.MarkovChain.get(\"gdq-final\");
	// return { reply: model.sentences(2) };
})',
		NULL,
		NULL
	)