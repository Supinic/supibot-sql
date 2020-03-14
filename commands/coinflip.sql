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
		Static_Data,
		Code,
		Examples,
		Dynamic_Description
	)
VALUES
	(
		32,
		'coinflip',
		'[\"cf\"]',
		'Flips a coin.',
		2500,
		0,
		0,
		1,
		0,
		NULL,
		0,
		0,
		0,
		1,
		1,
		0,
		NULL,
		'async () => {
	// According to Murray & Teare (1993), the probability of an American silver nickel landing on its edge is around 1 in 6000 tosses	
	const number =  sb.Utils.random(1, 6000);
	const flipResult = (number === 3000) ? null : Boolean(number < 3000);
	const replyMap = { true: \"Heads! (yes)\", false: \"Tails! (no)\", null: \"The coin landed on its edge!!\" };

	return {
		reply: replyMap[flipResult]
	};
}',
		'No arguments.

$coinflip',
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async () => {
	// According to Murray & Teare (1993), the probability of an American silver nickel landing on its edge is around 1 in 6000 tosses	
	const number =  sb.Utils.random(1, 6000);
	const flipResult = (number === 3000) ? null : Boolean(number < 3000);
	const replyMap = { true: \"Heads! (yes)\", false: \"Tails! (no)\", null: \"The coin landed on its edge!!\" };

	return {
		reply: replyMap[flipResult]
	};
}'