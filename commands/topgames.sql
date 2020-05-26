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
		118,
		'topgames',
		NULL,
		'ping,pipe',
		'Fetches the top 10 most popular games on twitch, based on current viewer count.',
		60000,
		NULL,
		NULL,
		'(async function topGames () {
	const data = await sb.Got.instances.Twitch.Kraken(\"games/top\").json();
	if (!Array.isArray(data.top)) {
		return {
			reply: \"No data retrieved...\"
		};
	}

	const games = data.top.map(i => (
		i.game.name + \" (\" + sb.Utils.round(i.viewers / 1000, 1) + \"k)\"
	));
	
	return {
		reply: \"Most popular games on Twitch by viewers right now: \" + games.join(\", \")
	};
})',
		NULL,
		'supinic/supibot-sql'
	)