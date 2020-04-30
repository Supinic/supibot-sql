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
		166,
		'countlinerecord',
		'[\"clr\"]',
		NULL,
		'Posts the two records of each channel: The amount, and the total length of messages posted within each one minute.',
		30000,
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
		NULL
	)