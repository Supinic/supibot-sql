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
		79,
		'dogfact',
		'[\"rdf\"]',
		'Fetches a random dog fact.',
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
		1,
		'async () => {
	const url = \"https://dog-api.kinduff.com/api/facts\";
	const data = JSON.parse(await sb.Utils.request(url));
	return {
		reply: (data.success) ? data.facts[0] : \"The API returned an internal error!\" 
	};
}',
		'No arguments.',
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async () => {
	const url = \"https://dog-api.kinduff.com/api/facts\";
	const data = JSON.parse(await sb.Utils.request(url));
	return {
		reply: (data.success) ? data.facts[0] : \"The API returned an internal error!\" 
	};
}'