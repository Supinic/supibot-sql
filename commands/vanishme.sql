INSERT INTO
	`chat_data`.`Command`
	(
		ID,
		Name,
		Aliases,
		Flags,
		Description,
		Cooldown,
		Whitelist_Response,
		Static_Data,
		Code,
		Dynamic_Description
	)
VALUES
	(
		14,
		'vanishme',
		NULL,
		'pipe,skip-banphrase,whitelist',
		'Posts !vanish',
		5000,
		NULL,
		NULL,
		'(async function vanishMe (context) {
	return {
		reply: \"!vanish monkaS\"
	};
})',
		NULL
	)