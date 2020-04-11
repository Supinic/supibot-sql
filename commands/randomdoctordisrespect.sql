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
		179,
		'randomdoctordisrespect',
		'[\"rdd\"]',
		NULL,
		'Posts a Markov chain-generated tweet from Dr. Disrespect.',
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
		'(async function () { 
	const model = await sb.MarkovChain.get(\"disrespect\");
	return {
		reply: model.sentences(3)
	};
});',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function () { 
	const model = await sb.MarkovChain.get(\"disrespect\");
	return {
		reply: model.sentences(3)
	};
});'