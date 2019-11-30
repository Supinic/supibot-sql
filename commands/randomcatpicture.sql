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
		83,
		'randomcatpicture',
		'[\"rcp\"]',
		'Fetches a picture of a random cat.',
		10000,
		0,
		0,
		0,
		1,
		'Only people who verified that they have a cat can use this command.',
		0,
		0,
		0,
		1,
		1,
		0,
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