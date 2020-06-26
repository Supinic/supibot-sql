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
		229,
		'streamgames',
		'[\"games\", \"sg\"]',
		'developer,ping,pipe,system,whitelist',
		'Posts the link to supinic\'s stream game list on Gist.',
		5000,
		NULL,
		'({
	gistID: \"80356bcd26fe15010ffbe211e5131228\"
})',
		'(async function streamGames () {
	return {
		reply: `https://gist.github.com/Supinic/${this.staticData.gistID}`
	};
})',
		NULL,
		'supinic/supibot-sql'
	)