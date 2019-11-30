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
		118,
		'topgames',
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
		'(async function topGames () {
	const data = JSON.parse(await sb.Utils.request({
		url: \"https://api.twitch.tv/kraken/games/top\",
		headers: {
			Accept: \"application/vnd.twitchtv.v5+json\",
			\"Client-ID\": sb.Config.get(\"TWITCH_CLIENT_ID\")
   		 }
	}));

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

ON DUPLICATE KEY UPDATE
	Code = '(async function topGames () {
	const data = JSON.parse(await sb.Utils.request({
		url: \"https://api.twitch.tv/kraken/games/top\",
		headers: {
			Accept: \"application/vnd.twitchtv.v5+json\",
			\"Client-ID\": sb.Config.get(\"TWITCH_CLIENT_ID\")
   		 }
	}));

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
})'