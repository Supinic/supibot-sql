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
		191,
		'content',
		NULL,
		NULL,
		'Shows how many suggestions there are Uncategorized and New - basically showing how much content I have for the next stream.',
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
		NULL,
		NULL
	)