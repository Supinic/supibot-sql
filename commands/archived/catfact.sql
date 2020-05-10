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
		78,
		'catfact',
		'[\"rcf\"]',
		'archived,pipe,whitelist',
		'Fetches a random cat fact.',
		10000,
		'Only people who verified that they have a cat can use this command. You can verify by using the $suggest command with a picture of your cat.',
		NULL,
		'(async function randomCatFact () {
	const url = \"https://catfact.ninja/fact\";
	const data = JSON.parse(await sb.Utils.request(url));
	
	return {
		reply: data.fact
	};
})',
		'async (prefix) => {
	return [
		\"Fetch a random cat-related fact!\",
		\"You can only use this command if you verified that you have cat.\",
		\"You can do this by using \" + prefix + \"suggest along with a picture of your cat, so Supinic can verify you.\",
		\"\",
		prefix + \"catfact => Many Egyptians worshipped the goddess Bast, who had a woman’s body and a cat’s head.\"
	];
}'
	)