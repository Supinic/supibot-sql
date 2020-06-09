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
		5,
		'V5',
		'function',
		'(() => ({
	prefixUrl: \"https://api.twitch.tv/v5\",
	responseType: \"json\",
	headers: {
		Accept: \"application/vnd.twitchtv.v5+json\",
		\"Client-ID\": sb.Config.get(\"TWITCH_CLIENT_ID\"),
		\"User-Agent\": sb.Config.get(\"DEFAULT_USER_AGENT\")
	}
}))',
		2,
		NULL
	)