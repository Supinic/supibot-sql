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
		83,
		'randomcatpicture',
		'[\"rcp\"]',
		'archived,ping,pipe,whitelist',
		'Fetches a picture of a random cat.',
		10000,
		'Only people who verified that they have a cat can use this command. You can verify by using the $suggest command with a picture of your cat.',
		NULL,
		'async () => {
	const url = \"https://api.thecatapi.com/v1/images/search\";
	const data = JSON.parse(await sb.Utils.request(url));

	return { reply: data[0].url };
}',
		NULL
	)