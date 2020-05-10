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
		179,
		'randomdoctordisrespect',
		'[\"rdd\"]',
		'ping,pipe',
		'Posts a Markov chain-generated tweet from Dr. Disrespect.',
		10000,
		NULL,
		NULL,
		'(async function () { 
	const model = await sb.MarkovChain.get(\"disrespect\");
	return {
		reply: model.sentences(3)
	};
});',
		NULL
	)