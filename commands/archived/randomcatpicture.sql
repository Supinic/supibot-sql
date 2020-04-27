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
		83,
		'randomcatpicture',
		'[\"rcp\"]',
		NULL,
		'Fetches a picture of a random cat.',
		10000,
		0,
		0,
		0,
		1,
		'Only people who verified that they have a cat can use this command. You can verify by using the $suggest command with a picture of your cat.',
		0,
		0,
		0,
		1,
		1,
		0,
		1,
		NULL,
		'async () => {
	const url = \"https://api.thecatapi.com/v1/images/search\";
	const data = JSON.parse(await sb.Utils.request(url));

	return { reply: data[0].url };
}',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async () => {
	const url = \"https://api.thecatapi.com/v1/images/search\";
	const data = JSON.parse(await sb.Utils.request(url));

	return { reply: data[0].url };
}'