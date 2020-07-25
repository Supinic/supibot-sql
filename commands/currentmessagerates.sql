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
		221,
		'currentmessagerates',
		'[\"cmr\"]',
		'mention,pipe',
		'Fetches the current messages/minute stats in the current channel.',
		10000,
		NULL,
		NULL,
		'(async function currentMessageRates (context) {
	if (!context.channel) {
		return {
			success: false,
			reply: `Can\'t check for messages rates in private messages!`
		};
	}

	const rates = await sb.Query.getRecordset(rs => rs
		.select(\"Amount\")
		.from(\"chat_data\", \"Message_Meta_Channel\")
		.where(\"Channel = %n\", context.channel.ID)
		.orderBy(\"Timestamp DESC\")
		.limit(1)
		.single()
	);

	return {
		reply: `Current message rates: ${rates?.Amount ?? 0} messages/minute.`
	};
})',
		NULL,
		'supinic/supibot-sql'
	)