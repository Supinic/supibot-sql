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
		12,
		'gamesdonequick',
		'[\"gdq\"]',
		'mention,pipe',
		'Posts a Markov chain-generated GDQ speedrun donation message.',
		10000,
		NULL,
		NULL,
		'(async function speedrun () {
	const { comment } = await sb.Got.instances.Leppunen(\"gdq\").json();
	return {
		reply: comment
	};
})',
		NULL,
		'supinic/supibot-sql'
	)