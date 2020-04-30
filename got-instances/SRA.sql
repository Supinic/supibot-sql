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
		'JSON',
		'{
	\"prefixUrl\": \"https://some-random-api.ml\"
}',
		NULL,
		'SRA = Some Random API (https://some-random-api.ml/)'
	)