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
		7,
		'Leppunen',
		'function',
		'(() => ({
	responseType: \"json\",
	prefixUrl: \"https://api.ivr.fi\",
	headers: {
		\"User-Agent\": sb.Config.get(\"DEFAULT_USER_AGENT\")
	},
	throwHttpErrors: false
}))',
		NULL,
		NULL
	)