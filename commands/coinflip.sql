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
		32,
		'coinflip',
		'[\"cf\"]',
		'ping,pipe,skip-banphrase',
		'Flips a coin.',
		2500,
		NULL,
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
		NULL,
		'supinic/supibot-sql'
	)