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
		13,
		'funfact',
		NULL,
		'ping,pipe',
		'Fetches a random fun fact. Absolutely not guaranteed to be fun or fact. Want to help out? Send us your own fun fact via the $suggest command!',
		60000,
		NULL,
		NULL,
		'(async function funFact () {
	const { year, month } = new sb.Date();
	const randomDate = new sb.Date(
		sb.Utils.random(2017, year),
		sb.Utils.random(1, 12)
	);

	const rawData = await sb.Got({
		prefixUrl: \"https://uselessfacts.net/api\",
		url: \"posts\",
		searchParams: \"d=\" + randomDate.toJSON()
	}).json();

	const data = rawData.filter(i => i._id !== this.data.previousFactID);
	if (data.length === 0) {
		return {
			reply: \"No fun facts found :(\"
		};
	}

	const randomFact = sb.Utils.randArray(data);
	this.data.previousFactID = randomFact._id;

	return {
		reply: randomFact.title
	};
})',
		NULL,
		'supinic/supibot-sql'
	)