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
		190,
		'randomfilm',
		'[\"rf\"]',
		'mention,pipe',
		'Fetches a random movie.',
		15000,
		NULL,
		NULL,
		'(async function randomFilm () {
	const html = await sb.Got.instances.FakeAgent({
		url: \"https://www.bestrandoms.com/random-movie-generator\"
	}).text();

	const $ = sb.Utils.cheerio(html);
	const movies = $(\".list-unstyled.content li\").map((ind, i) => {
		const name = $($(i).children()[0]);
		return name.text().replace(/\\s+/g, \" \");		
	});

	return {
		reply: `Your random movie is: ${sb.Utils.randArray(movies)}.`
	};
})',
		NULL,
		'supinic/supibot-sql'
	)