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
		'JSON',
		'{
	\"prefixUrl\": \"https://api.github.com\",
	\"headers\": {
		\"User-Agent\": \"supibot @ github.com/supinic/supibot\"
	}
}',
		NULL,
		NULL
	)