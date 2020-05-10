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
		82,
		'randomdogpicture',
		'[\"rdp\"]',
		'archived,ping,pipe,whitelist',
		'Fetches a random dog picture.',
		10000,
		'Only people who verified that they have a dog can use this command. You can verify by using the $suggest command with a picture of your dog.',
		NULL,
		'async () => {
	const url = \"https://dog.ceo/api/breeds/image/random\";
	const data = JSON.parse(await sb.Utils.request(url));

	return { reply: data.message };
}',
		NULL
	)