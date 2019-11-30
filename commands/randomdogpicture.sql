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
		82,
		'randomdogpicture',
		'[\"rdp\"]',
		'Fetches a random dog picture.',
		10000,
		0,
		0,
		0,
		1,
		'Only people who verified that they have a dog can use this command.',
		0,
		0,
		0,
		1,
		1,
		0,
		'async () => {
	const url = \"https://dog.ceo/api/breeds/image/random\";
	const data = JSON.parse(await sb.Utils.request(url));

	return { reply: data.message };
}',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async () => {
	const url = \"https://dog.ceo/api/breeds/image/random\";
	const data = JSON.parse(await sb.Utils.request(url));

	return { reply: data.message };
}'