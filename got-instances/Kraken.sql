INSERT INTO
	`data`.`Got_Instance`
	(
		ID,
		Name,
		Options_Type,
		Options,
		Parent,
		Description
	)
VALUES
	(
		8,
		'Kraken',
		'function',
		'(() => ({
	prefixUrl: \"https://api.twitch.tv/kraken\",
	responseType: \"json\",
	resolveBodyOnly: true,
	headers: {
		\"Accept\": \"application/vnd.twitchtv.v5+json\",
		\"Client-ID\": sb.Config.get(\"TWITCH_CLIENT_ID\"),
		\"User-Agent\": sb.Config.get(\"DEFAULT_USER_AGENT\")
	},
	mutableDefaults: true
}))',
		2,
		NULL
	)