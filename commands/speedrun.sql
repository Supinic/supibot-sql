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
		218,
		'speedrun',
		NULL,
		'ping',
		'Fetches the current world record speedrun of a given name in the default category. Check extended help for more info.',
		10000,
		NULL,
		NULL,
		'(async function speedrun (context, ...args) {
	let fetchCategories = false;
	let categoryName = null;
	for (let i = 0; i < args.length; i++) {
		const token = args[i];
		if (token.includes(\"category:\")) {
			categoryName = token.split(\":\")[1]?.toLowerCase() ?? null;
			args.splice(i, 1);
		}
		else if (token.includes(\"categories\")) {
			fetchCategories = true;
			args.splice(i, 1);
		}
	}

	const gameName = args.join(\" \");
	if (!gameName) {
		return {
			success: false,
			reply: `No input provided!`
		};
	}

	const { data: gameData } = await sb.Got.instances.Speedrun({
		url: \"games\",
		searchParams: new sb.URLParams()
			.set(\"name\", gameName)
			.toString()
	}).json();

	if (gameData.length === 0) {
		return {
			success: false,
			reply: `No such game found!`
		};
	}

	const [game] = gameData;
	const { data: categoryData } = await sb.Got.instances.Speedrun(`games/${game.id}/categories`).json();

	if (fetchCategories) {
		return {
			reply: `Available categories for ${game.names.international}: ${categoryData.map(i => i.name).join(\", \")}.`
		};
	}

	let category = null;
	if (categoryName === null) {
		category = categoryData[0];
	}
	else {
		category = categoryData.find(i => i.name.toLowerCase().includes(categoryName));
	}

	if (!category) {
		return {
			success: false,
			reply: `No such category found! Try one of thise: ${categoryData.map(i => i.name).join(\", \")}`
		};
	}

	const { data: runsData } = await sb.Got.instances.Speedrun({
		url: `leaderboards/${game.id}/category/${category.id}`,
		searchParam: \"top=1\"
	}).json();

	if (runsData.runs.length === 0) {
		return {
			reply: `${game.names.international} - ${category.name} has no runs.`
		};
	}

	const { run } = runsData.runs[0];
	const { data: runnerData } = await sb.Got.instances.Speedrun(`users/${run.players[0].id}`).json();

	const delta = sb.Utils.timeDelta(new sb.Date(run.date));
	const time = sb.Utils.formatTime(run.times.primary_t, true);
	return {
		reply: `Current WR for ${game.names.international}, ${category.name}: ${time} by ${runnerData.names.international}, run ${delta}.`
	};
})',
		'async (prefix) => {
	return [
		`Searches <a href=\"//speedrun.com\">speedrun.com</a> for the world record run of a given game.`,
		`You can also specify categories. If you don\'t, the \"default\" one will be used.`,
		\"\",

		`<code>${prefix}speedrun Doom II</code>`,
		\"Searches for the world record run of Doom II\'s default category (Hell on Earth).\",
		\"\",

		`<code>${prefix}speedrun Doom II category:UV</code>`,
		\"Searches for the world record run of Doom II\'s UV Speed category.\",
		\"\",

		`<code>${prefix}speedrun Doom II categories</code>`,
		\"Posts a list of all tracked categories for Doom II.\",
	];
}',
		'supinic/supibot-sql'
	)