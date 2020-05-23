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
		10,
		'SRA',
		'function',
		'(() => ({
	prefixUrl: \"https://some-random-api.ml\",
	responseType: \"json\",
	headers: {		
		\"User-Agent\": sb.Config.get(\"DEFAULT_USER_AGENT\")
	}
}))',
		NULL,
		'SRA = Some Random API (https://some-random-api.ml/)'
	)