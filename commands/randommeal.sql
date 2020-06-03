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
		223,
		'randommeal',
		'[\"rmeal\"]',
		'ping,pipe',
		'Searches for a meal recipe by its name, or fetches a random one, if no search query was provided.',
		10000,
		NULL,
		NULL,
		'(async function randomMeal (context, ...args) {
	let data = null;
	if (args.length === 0) {
		data = await sb.Got(\"https://www.themealdb.com/api/json/v1/1/random.php\").json();
	}
	else {
		data = await sb.Got({
			url: \"https://www.themealdb.com/api/json/v1/1/search.php\",
			searchParams: new sb.URLParams()
				.set(\"s\", args.join(\" \"))
				.toString()
		}).json();

		if (!data?.meals) {
			return {
				success: false,
				reply: \"No recipes found for that query!\"
			};
		}
	}
	
	const meal = sb.Utils.randArray(data.meals);
	const ingredients = Object.entries(meal).filter(([key, value]) => /ingredient\\d+/i.test(key)).map(([key, value]) => value).filter(Boolean);

	return {
		reply: `${meal.strMeal} - Ingredients: ${ingredients.join(\", \")} ${meal.strYoutube}`
	};
})',
		NULL,
		'supinic/supibot-sql'
	)