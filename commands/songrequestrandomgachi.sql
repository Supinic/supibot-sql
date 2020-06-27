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
		180,
		'songrequestrandomgachi',
		'[\"gsr\", \"srg\", \"srrg\"]',
		'skip-banphrase,whitelist',
		'Posts a random gachi in the format \"!sr <link>\" to use on other bots\' song request systems (such as StreamElements).',
		60000,
		'Only available in specific whitelisted channels (for instance, those that have a song request bot that replies to \"!sr\").',
		'({
	repeatLimit: 5
})',
		'(async function songRequestRandomGachi (context, ...args) {
	let link = null;
	let counter = 0;
	const rg = sb.Command.get(\"rg\");

	while (!link && counter < this.staticData.repeatLimit) {
		const { reply } = await rg.execute({}, \"linkOnly:true\", ...args);
		const data = await sb.Utils.linkParser.fetchData(reply);

		if (data === null) {
			counter++;

			const videoID = sb.Utils.linkParser.parseLink(reply);
			await sb.Query.getRecordUpdater(ru => ru
				.update(\"music\", \"Track\")
				.set(\"Available\", false)
				.where(\"Link = %s\", videoID)
			);
		}
		else {
			link = reply;
		}
	}

	if (counter >= this.staticData.repeatLimit) {
		return {
			success: false,
			reply: `Video fetching failed ${this.staticData.repeatLimit} times! Aborting request...`
		};
	}

	return {
		reply: `!sr ${link}`
	}
})',
		NULL,
		'supinic/supibot-sql'
	)