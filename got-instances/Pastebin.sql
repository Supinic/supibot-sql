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
		14,
		'Pastebin',
		'function',
		'(() => ({
	prefixUrl: \"https://pastebin.com/\",
	headers: {
		\"Content-Type\": \"application/x-www-form-urlencoded\",
		\"User-Agent\": sb.Config.get(\"DEFAULT_USER_AGENT\")
	}
}))',
		NULL,
		NULL
	)