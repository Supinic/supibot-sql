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
		180,
		'songrequestrandomgachi',
		'[\"srg\", \"srrg\"]',
		'Posts a random gachi in the format \"!sr <link>\" to use on other bots\' song request systems (such as StreamElements).',
		60000,
		0,
		0,
		1,
		1,
		'Only available in specific channels (that have a song request bot, like StreamElements).',
		0,
		0,
		0,
		0,
		0,
		0,
		'(async function streamElementsGachi (context) {
	const rg = sb.Command.get(\"rg\");
	return {
		reply: \"!sr \" + (await rg.execute({}, \"linkOnly:true\")).reply
	}
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function streamElementsGachi (context) {
	const rg = sb.Command.get(\"rg\");
	return {
		reply: \"!sr \" + (await rg.execute({}, \"linkOnly:true\")).reply
	}
})'