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
		190,
		'randomfilm',
		'[\"rf\"]',
		NULL,
		'Fetches a random movie.',
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
		NULL
	)