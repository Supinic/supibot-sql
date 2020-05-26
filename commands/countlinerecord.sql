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
		166,
		'countlinerecord',
		'[\"clr\"]',
		'ping,pipe',
		'Posts the two records of each channel: The amount, and the total length of messages posted within each one minute.',
		30000,
		NULL,
		NULL,
		'(async function countLineRecord (context) {
	const [amountData, lengthData] = await Promise.all([
		sb.Query.getRecordset(rs => rs
			.select(\"Amount\", \"Timestamp\")
			.from(\"chat_data\", \"Message_Meta_Channel\")
			.where(\"Channel = %n\", context.channel.ID)
			.orderBy(\"Amount DESC\")
			.limit(1)
			.single()
		),

		sb.Query.getRecordset(rs => rs
			.select(\"Length\", \"Timestamp\")		
			.from(\"chat_data\", \"Message_Meta_Channel\")
			.where(\"Channel = %n\", context.channel.ID)
			.orderBy(\"Length DESC\")
			.limit(1)
			.single()
		)
	]);

	return {
		reply: [
			\"This channel\'s records are\",
			amountData.Amount + \" messages/min\",
			\"(\" + amountData.Timestamp.format(\"Y-m-d H:i\") + \");\",
			\"and\",
			sb.Utils.round(lengthData.Length / 1000, 2) + \" kB/min\",
			\"(\" + lengthData.Timestamp.format(\"Y-m-d H:i\") + \")\"
		].join(\" \")
	};		
})',
		NULL,
		'supinic/supibot-sql'
	)