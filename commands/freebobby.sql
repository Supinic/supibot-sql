INSERT INTO
	`chat_data`.`Command`
	(
		ID,
		Name,
		Aliases,
		Flags,
		Description,
		Cooldown,
		Rollbackable,
		System,
		Skip_Banphrases,
		Whitelisted,
		Whitelist_Response,
		Read_Only,
		Opt_Outable,
		Blockable,
		Ping,
		Pipeable,
		Owner_Override,
		Archived,
		Static_Data,
		Code,
		Examples,
		Dynamic_Description
	)
VALUES
	(
		137,
		'freebobby',
		NULL,
		NULL,
		'When is Bobby Shmurda going to be freed? TriHard',
		15000,
		0,
		0,
		0,
		0,
		NULL,
		0,
		0,
		0,
		1,
		1,
		0,
		0,
		NULL,
		'async () => {
	const free = new sb.Date(\"2020-12-11\");
	return { reply: \"Our boy might be free \" + sb.Utils.timeDelta(free) + \" if he gets his parole TriHard\" };
}',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async () => {
	const free = new sb.Date(\"2020-12-11\");
	return { reply: \"Our boy might be free \" + sb.Utils.timeDelta(free) + \" if he gets his parole TriHard\" };
}'