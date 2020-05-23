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
		15,
		'Vimeo',
		'function',
		'(() => ({
	prefixUrl: \"https://api.vimeo.com\",
	responseType: \"json\",
	headers: {
		\"Authorization\": \"Bearer \" + sb.Config.get(\"VIMEO_API_KEY\"),
		\"User-Agent\": sb.Config.get(\"DEFAULT_USER_AGENT\")
	}
}))',
		NULL,
		NULL
	)