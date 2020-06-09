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
		6,
		'GitHub',
		'function',
		'(() => ({
	responseType: \"json\",
	prefixUrl: \"https://api.github.com\",
	throwHttpErrors: false,
	headers: {
		\"User-Agent\": sb.Config.get(\"DEFAULT_USER_AGENT\")
	}
}))',
		NULL,
		NULL
	)