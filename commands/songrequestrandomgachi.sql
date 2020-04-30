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
		180,
		'songrequestrandomgachi',
		'[\"gsr\", \"srg\", \"srrg\"]',
		NULL,
		'Posts a random gachi in the format \"!sr <link>\" to use on other bots\' song request systems (such as StreamElements).',
		60000,
		0,
		0,
		1,
		1,
		'Only available in specific whitelisted channels (for instance, those that have a song request bot that replies to \"!sr\").',
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		NULL,
		'(async function streamElementsGachi (context) {
	const rg = sb.Command.get(\"rg\");
	return {
		reply: \"!sr \" + (await rg.execute({}, \"linkOnly:true\")).reply
	}
})',
		NULL,
		NULL
	)