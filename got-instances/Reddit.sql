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
		13,
		'Reddit',
		'function',
		'(() => ({
	prefixUrl: \"https://www.reddit.com/r/\",
	responseType: \"json\",
	throwHttpErrors: false,
	headers: {
		\"Cookie\": \"_options={%22pref_quarantine_optin%22:true};\",
		\"User-Agent\": sb.Config.get(\"DEFAULT_USER_AGENT\")
	}
}))',
		NULL,
		NULL
	)