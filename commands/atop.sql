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
		62,
		'atop',
		NULL,
		'Fetches the top 10 users by total amount of chat lines across all channels. This is a very heavy operation on SQL, so please use it sparingly.',
		0,
		0,
		1,
		0,
		1,
		NULL,
		0,
		0,
		0,
		1,
		1,
		0,
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
		'No arguments.
Cannot be used on other people.

$atop
$atop <someone> => still shows your lines, not theirs.',
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function atop () {
	const top = (await sb.Query.getRecordset(rs => rs
		.select(\"Name\", \"SUM(Message_Count) AS Total\")
		.from(\"chat_data\", \"Message_Meta_User_Alias\")
		.join(\"chat_data\", \"User_Alias\")
		.groupBy(\"User_Alias\")
		.orderBy(\"SUM(Message_Count) DESC\")
		.limit(10)
	)).map(i => i.Name + \": \" + i.Total).join(\"; \")

	return { reply: \"Top users by total chat lines across all channels: \" + top };
})'