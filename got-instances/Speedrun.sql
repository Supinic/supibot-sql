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
		16,
		'Speedrun',
		'function',
		'(() => ({
	prefixUrl: \"https://www.speedrun.com/api/v1\",
	headers: {
		\"User-Agent\": sb.Config.get(\"DEFAULT_USER_AGENT\")
	}
}))',
		NULL,
		NULL
	)