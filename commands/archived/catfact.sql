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
		78,
		'catfact',
		'[\"rcf\"]',
		NULL,
		'Fetches a random cat fact.',
		10000,
		0,
		0,
		0,
		1,
		'Only people who verified that they have a cat can use this command. You can verify by using the $suggest command with a picture of your cat.',
		0,
		0,
		0,
		0,
		1,
		0,
		1,
		NULL,
		'(async function randomCatFact () {
	const url = \"https://catfact.ninja/fact\";
	const data = JSON.parse(await sb.Utils.request(url));
	
	return {
		reply: data.fact
	};
})',
		'No arguments.

$catfact',
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

ON DUPLICATE KEY UPDATE
	Code = '(async function randomCatFact () {
	const url = \"https://catfact.ninja/fact\";
	const data = JSON.parse(await sb.Utils.request(url));
	
	return {
		reply: data.fact
	};
})'