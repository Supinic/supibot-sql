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
		58,
		'randomlineextra',
		'[\"rlx\"]',
		'Posts a random message from a special set of channels on Twitch. You should be able to identify the channel by its emoji.',
		7500,
		0,
		0,
		0,
		0,
		NULL,
		0,
		0,
		0,
		0,
		1,
		0,
		'async (extra) => {
	const channels = sb.Config.get(\"EXTRA_RANDOM_LINE_CHANNELS\");
	const [channel, emoji] = sb.Utils.randArray(Object.entries(channels));

	const maxID = (await sb.Query.getRecordset(rs => rs
		.select(\"MAX(ID) AS MaxID\")
		.from(\"chat_line\", channel)
	))[0].MaxID;

	const line = (await sb.Query.getRecordset(rs => rs
		.select(\"Text\")
		.from(\"chat_line\", channel)
		.where(\"ID = %n\", sb.Utils.random(1, maxID))
	))[0].Text.replace(sb.Config.get(\"LINK_REGEX\"), \"[LINK]\");

	return { reply: emoji + \" \" + line };
};',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async (extra) => {
	const channels = sb.Config.get(\"EXTRA_RANDOM_LINE_CHANNELS\");
	const [channel, emoji] = sb.Utils.randArray(Object.entries(channels));

	const maxID = (await sb.Query.getRecordset(rs => rs
		.select(\"MAX(ID) AS MaxID\")
		.from(\"chat_line\", channel)
	))[0].MaxID;

	const line = (await sb.Query.getRecordset(rs => rs
		.select(\"Text\")
		.from(\"chat_line\", channel)
		.where(\"ID = %n\", sb.Utils.random(1, maxID))
	))[0].Text.replace(sb.Config.get(\"LINK_REGEX\"), \"[LINK]\");

	return { reply: emoji + \" \" + line };
};'