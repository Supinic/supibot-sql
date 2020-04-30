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
		82,
		'randomdogpicture',
		'[\"rdp\"]',
		NULL,
		'Fetches a random dog picture.',
		10000,
		0,
		0,
		0,
		1,
		'Only people who verified that they have a dog can use this command. You can verify by using the $suggest command with a picture of your dog.',
		0,
		0,
		0,
		1,
		1,
		0,
		1,
		NULL,
		'async () => {
	const url = \"https://dog.ceo/api/breeds/image/random\";
	const data = JSON.parse(await sb.Utils.request(url));

	return { reply: data.message };
}',
		NULL,
		NULL
	)