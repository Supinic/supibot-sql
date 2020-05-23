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
		12,
		'Google',
		'function',
		'(() => ({
	prefixUrl: \"https://maps.googleapis.com/maps/api\",
	responseType: \"json\",
	headers: {		
		\"User-Agent\": sb.Config.get(\"DEFAULT_USER_AGENT\")
	}
}))',
		NULL,
		NULL
	)