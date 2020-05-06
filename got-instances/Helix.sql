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
		\"User-Agent\": \"twitch.tv/supibot @ github.com/supinic/supibot\"
	}
}))',
		2,
		NULL
	)