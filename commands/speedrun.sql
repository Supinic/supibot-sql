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
		12,
		'speedrun',
		'[\"gdq\"]',
		'ping,pipe',
		'Posts a Markov chain-generated GDQ speedrun donation message.',
		10000,
		NULL,
		NULL,
		'(async function speedrun () {
	const { comment } = await sb.Got.instances.Leppunen(\"gdq\").json();
	return {
		reply: comment
	};

	// const model = await sb.MarkovChain.get(\"gdq-final\");
	// return { reply: model.sentences(2) };
})',
		NULL
	)