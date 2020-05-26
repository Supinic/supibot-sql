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
		58,
		'randomlineextra',
		'[\"rlx\"]',
		'block,pipe',
		'Posts a random message from a special set of channels on Twitch. You should be able to identify the channel by its emoji.',
		7500,
		NULL,
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
		'supinic/supibot-sql'
	)