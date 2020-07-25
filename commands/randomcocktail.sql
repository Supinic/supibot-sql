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
		224,
		'randomcocktail',
		'[\"cock\", \"drinks\", \"tail\"]',
		'mention,pipe',
		'Searches for a cocktail recipe by its name, or fetches a random one, if no search query was provided.',
		10000,
		NULL,
		NULL,
		'(async function randomCocktail (context, ...args) {
	let data = null;
	if (args.length === 0) {
		data = await sb.Got(\"https://www.thecocktaildb.com/api/json/v1/1/random.php\").json();
	}
	else {
		data = await sb.Got({
			url: \"https://www.thecocktaildb.com/api/json/v1/1/search.php\",
			searchParams: new sb.URLParams()
				.set(\"s\", args.join(\" \"))
				.toString()
		}).json();

		if (!data?.drinks) {
			return {
				success: false,
				reply: \"No cocktails found for that query!\"
			};
		}
	}
	
	const drink = sb.Utils.randArray(data.drinks);
	const ingredients = Object.entries(drink).filter(([key, value]) => /ingredient\\d+/i.test(key)).map(([key, value]) => value).filter(Boolean);

	return {
		reply: `${drink.strDrink} (${ingredients.join(\", \")}): ${drink.strInstructions}`
	};
})',
		NULL,
		'supinic/supibot-sql'
	)