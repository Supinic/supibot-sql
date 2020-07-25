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
		79,
		'dogfact',
		'[\"rdf\"]',
		'archived,mention,pipe,whitelist',
		'Fetches a random dog fact.',
		10000,
		'Only people who verified that they have a dog can use this command. You can verify by using the $suggest command with a picture of your dog.',
		NULL,
		'async () => {
	const url = \"https://dog-api.kinduff.com/api/facts\";
	const data = JSON.parse(await sb.Utils.request(url));
	return {
		reply: (data.success) ? data.facts[0] : \"The API returned an internal error!\" 
	};
}',
		NULL,
		'supinic/supibot-sql'
	)