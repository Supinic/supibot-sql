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
		2,
		'Twitch',
		'function',
		'(() => ({
	prefixUrl: \"https://twitch.tv\",
	headers: {
		Authorization: sb.Config.get(\"TWITCH_OAUTH\"),
		\"User-Agent\": \"twitch.tv/supibot @ github.com/supinic/supibot\"
	}
}))',
		NULL,
		NULL
	)