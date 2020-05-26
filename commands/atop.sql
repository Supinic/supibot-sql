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
		62,
		'atop',
		NULL,
		'ping,pipe,system,whitelist',
		'Fetches the top 10 users by total amount of chat lines across all channels. This is a very heavy operation on SQL, so please use it sparingly.',
		0,
		NULL,
		NULL,
		'(async function atop () {
	const top = (await sb.Query.getRecordset(rs => rs
		.select(\"Name\", \"SUM(Message_Count) AS Total\")
		.from(\"chat_data\", \"Message_Meta_User_Alias\")
		.join(\"chat_data\", \"User_Alias\")
		.groupBy(\"User_Alias\")
		.orderBy(\"SUM(Message_Count) DESC\")
		.limit(10)
	)).map(i => i.Name + \": \" + i.Total).join(\"; \")

	return { reply: \"Top users by total chat lines across all channels: \" + top };
})',
		NULL,
		'supinic/supibot-sql'
	)