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
		Dynamic_Description
	)
VALUES
	(
		218,
		'speedrun',
		NULL,
		'ping',
		NULL,
		10000,
		NULL,
		NULL,
		'(async function speedrun (context, ...args) {
	let categoryName = null;
	for (let i = 0; i < args.length; i++) {
		const token = args[i];
		if (token.includes(\"category:\")) {
			categoryName = token.split(\":\")[1]?.toLowerCase() ?? null;
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

	const { data: gameData } = await sb.Got({
		url: \"https://www.speedrun.com/api/v1/games\",
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
	const { data: categoryData } = await sb.Got({
		url: `https://www.speedrun.com/api/v1/games/${game.id}/categories`
	}).json();

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

	const { data: runsData } = await sb.Got({
		url: `https://www.speedrun.com/api/v1/leaderboards/${game.id}/category/${category.id}`,
		searchParam: \"top=1\"
	}).json();

	const { run } = runsData.runs[0];
	const { data: runnerData } = await sb.Got({
		url: `https://www.speedrun.com/api/v1/users/${run.players[0].id}`
	}).json();

	const delta = sb.Utils.timeDelta(new sb.Date(run.date));
	const time = sb.Utils.formatTime(run.times.primary_t, true);
	return {
		reply: `Current WR for ${game.names.international}, ${category.name}: ${time} by ${runnerData.names.international}, run ${delta}.`
	};
})',
		NULL
	)