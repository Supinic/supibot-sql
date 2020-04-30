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
		1,
		'Supinic',
		'JSON',
		'{
	\"prefixUrl\": \"http://192.168.0.101/api\",
	\"responseType\": \"json\",
	\"throwHttpErrors\": false,
	\"mutableDefaults\": true,
	\"headers\": {
		\"User-Agent\": \"Supibot github.com/supinic/supibot\"
	}
}',
		NULL,
		NULL
	)