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
		27,
		'%',
		NULL,
		'mention,pipe,skip-banphrase',
		'Rolls a random percentage between 0 and 100%',
		5000,
		NULL,
		NULL,
		'(async function percent () {
	const number = (sb.Utils.random(0, 10000) / 100);
	return { reply: number + \"%\" };
})',
		'async (prefix) => [
	\"Rolls a random percentage number between 0% and 100%.\",
	\"\",

	`<code>${prefix}%</code>`,
	(sb.Utils.random(0, 10000) / 100) + \"%\"
]	',
		'supinic/supibot-sql'
	)