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
		Dynamic_Description
	)
VALUES
	(
		191,
		'content',
		NULL,
		'ping,pipe',
		'Shows how many suggestions there are Uncategorized and New - basically showing how much content I have for the next stream.',
		30000,
		NULL,
		NULL,
		'(async function content () {
	const data = await sb.Query.getRecordset(rs => rs
		.select(\"ID\", \"Category\", \"Status\")
		.from(\"data\", \"Suggestion\")
	);

	const count = {
		new: data.filter(i => i.Category === \"Uncategorized\" && i.Status === \"New\").length,
		approved: data.filter(i => i.Status === \"Approved\").length
	};	

	return {
		reply: `Content status: ${count.new} new suggestions, ${count.approved} are approved and waiting!`
	};
})',
		NULL
	)