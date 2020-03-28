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
		Static_Data,
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
		'({
	channels: {
		\"amouranth\": \"💃🏼\",
		\"athenelive\": \"🇫🇷🤖\",
		\"drdisrespect\": \"💿\",
		\"drdisrespectlive\": \"💿\",
		\"ninja\": \"👤\",
		\"stpeach\": \"🍑\",
		\"alinity\": \"🍝👩💰\",
		\"p4wnyhof\": \"🇩🇪🤖\",
		\"pokimane\": \"😍\"
	}
})',
		'(async function randomLineExtra () {
	const [channel, emoji] = sb.Utils.randArray(Object.entries(this.staticData.channels));
	const max = (await sb.Query.getRecordset(rs => rs
		.select(\"MAX(ID) AS ID\")
		.from(\"chat_line\", channel)
		.single()
	));

	const line = (await sb.Query.getRecordset(rs => rs
		.select(\"Text\")
		.from(\"chat_line\", channel)
		.where(\"ID = %n\", sb.Utils.random(1, max.ID))
		.single()
	));

	return {
		reply: `${emoji} ${line.Text}`
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function randomLineExtra () {
	const [channel, emoji] = sb.Utils.randArray(Object.entries(this.staticData.channels));
	const max = (await sb.Query.getRecordset(rs => rs
		.select(\"MAX(ID) AS ID\")
		.from(\"chat_line\", channel)
		.single()
	));

	const line = (await sb.Query.getRecordset(rs => rs
		.select(\"Text\")
		.from(\"chat_line\", channel)
		.where(\"ID = %n\", sb.Utils.random(1, max.ID))
		.single()
	));

	return {
		reply: `${emoji} ${line.Text}`
	};
})'