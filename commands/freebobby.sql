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
		Dynamic_Description,
		Source
	)
VALUES
	(
		137,
		'freebobby',
		NULL,
		'mention,pipe',
		'When is Bobby Shmurda going to be freed? TriHard',
		15000,
		NULL,
		NULL,
		'async () => {
	const free = new sb.Date(\"2020-12-11\");
	return { reply: \"Our boy might be free \" + sb.Utils.timeDelta(free) + \" if he gets his parole TriHard\" };
}',
		NULL,
		'supinic/supibot-sql'
	)