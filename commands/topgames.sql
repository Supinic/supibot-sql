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
		118,
		'topgames',
		NULL,
		NULL,
		'Fetches the top 10 most popular games on twitch, based on current viewer count.',
		60000,
		0,
		0,
		0,
		0,
		NULL,
		0,
		0,
		0,
		1,
		1,
		0,
		0,
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
		NULL
	)