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
		11,
		'Mixer',
		'function',
		'(() => ({
	prefixUrl: \"https://mixer.com/api/v1\",
	responseType: \"json\",
	headers: {		
		\"User-Agent\": sb.Config.get(\"DEFAULT_USER_AGENT\")
	}
}))',
		NULL,
		NULL
	)