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
		9,
		'CommanderRoot',
		'function',
		'(() => ({
	prefixUrl: \"https://twitch-tools.rootonline.de\",
	responseType: \"json\",
	headers: {		
		\"User-Agent\": sb.Config.get(\"DEFAULT_USER_AGENT\")
	}
}))',
		NULL,
		NULL
	)