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
		'JSON',
		'{
	\"prefixUrl\": \"https://api.ivr.fi\",
	\"headers\": {
		\"User-Agent\": \"Supibot @ github.com/supinic/supibot\"
	},
	\"throwHttpErrors\": false
}',
		NULL,
		NULL
	)