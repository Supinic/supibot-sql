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
		3,
		'Helix',
		'function',
		'(() => ({
	prefixUrl: \"https://api.twitch.tv/helix\",
	responseType: \"json\",
	headers: {
		\"Client-ID\": sb.Config.get(\"TWITCH_CLIENT_ID\"),
		\"Authorization\": `Bearer ${sb.Config.get(\"TWITCH_APP_ACCESS_TOKEN\")}`,
		\"User-Agent\": sb.Config.get(\"DEFAULT_USER_AGENT\")
	}
}))',
		2,
		NULL
	)