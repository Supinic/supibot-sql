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
		208,
		'ForeverAlone',
		NULL,
		NULL,
		NULL,
		10000,
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
		'({
	fetchGamesData: async () => {
		const data = await sb.Got.instances.FakeAgent({
			method: \"POST\",
			url: \"https://www.egirl.gg/api/web/product-type/list-by-game?\"
		}).json();

		return JSON.stringify(data.content.map(i => ({
			ID: i.id,
			name: i.nameEn,
			gameID: i.gameNum
		})).sort((a, b) => a.ID - b.ID), null, 4);
	},

	games: [
		{
			ID: 1,
			name: \"CS:GO\",
			gameID: 656
		},
		{
			ID: 2,
			name: \"Dota 2\",
			gameID: 129
		},
		{
			ID: 3,
			name: \"PUBG\",
			gameID: 65
		},
		{
			ID: 4,
			name: \"League of Legends\",
			gameID: 5108
		},
		{
			ID: 5,
			name: \"Fortnite\",
			gameID: 689
		},
		{
			ID: 6,
			name: \"Minecraft\",
			gameID: 947
		},
		{
			ID: 7,
			name: \"Overwatch\",
			gameID: 1308
		},
		{
			ID: 8,
			name: \"Hearthstone\",
			gameID: 65
		},
		{
			ID: 9,
			name: \"Gwent\",
			gameID: 13
		},
		{
			ID: 10,
			name: \"Heroes of the Storm\",
			gameID: 59
		},
		{
			ID: 11,
			name: \"World of Warcraft\",
			gameID: 205
		},
		{
			ID: 12,
			name: \"Apex Legends\",
			gameID: 402
		},
		{
			ID: 13,
			name: \"VR Chat\",
			gameID: 232
		},
		{
			ID: 14,
			name: \"Dead by Daylight\",
			gameID: 257
		},
		{
			ID: 15,
			name: \"Rocket League\",
			gameID: 116
		},
		{
			ID: 16,
			name: \"Smash bro\",
			gameID: 127
		},
		{
			ID: 17,
			name: \"Roblox\",
			gameID: 182
		},
		{
			ID: 18,
			name: \"Call of Duty\",
			gameID: 468
		},
		{
			ID: 19,
			name: \"Animal Crossing: New Horizons\",
			gameID: 48
		},
		{
			ID: 20,
			name: \"Rainbow Six\",
			gameID: 46
		},
		{
			ID: 21,
			name: \"Grand Theft Auto V\",
			gameID: 12
		},
		{
			ID: 22,
			name: \"Osu!\",
			gameID: 36
		},
		{
			ID: 23,
			name: \"Destiny 2\",
			gameID: 13
		},
		{
			ID: 24,
			name: \"Pokémon Sword/Shield\",
			gameID: 2
		},
		{
			ID: 25,
			name: \"Monster Hunter World\",
			gameID: 20
		},
		{
			ID: 26,
			name: \"Final Fantasy XIV Online\",
			gameID: 15
		},
		{
			ID: 27,
			name: \"Borderlands 3\",
			gameID: 4
		},
		{
			ID: 28,
			name: \"Black Desert Online\",
			gameID: 4
		},
		{
			ID: 29,
			name: \"Legends of Runeterra\",
			gameID: 6
		},
		{
			ID: 30,
			name: \"Escape From Tarkov\",
			gameID: 11
		},
		{
			ID: 31,
			name: \"Slither io\",
			gameID: 16
		}
	]
})',
		'(async function something (context, ...args) {
	let game = sb.Utils.randArray(this.staticData.games);
	let selectedSex = \"1\";

	for (const token of args) {
		if (token.includes(\"game:\")) {
			const name = token.replace(\"game:\", \"\").toLowerCase();
			game = this.staticData.games.find(i => i.name.toLowerCase().includes(name));

			if (!game) {
				return {
					reply: \"Could not match your provided game!\"
				};
			}
		}
		else if (token.includes(\"gender:\") || token.includes(\"sex:\")) {
			const gender = token.replace(\"gender:\", \"\").replace(\"sex:\", \"\").toLowerCase();
			if (gender === \"male\") {
				selectedSex = \"0\";
			}
			else if (gender === \"female\") {
				selectedSex = \"1\";
			}
			else {
				return {
					reply: \"Could not match your provided gender!\"
				};
			}
		}
	}

	const { statusCode, body: data } = await sb.Got.instances.FakeAgent({
		method: \"POST\",
		throwHttpErrors: false,
		responseType: \"json\",
		url: \"https://www.egirl.gg/api/web/home/random-recommend\",
		searchParams: new sb.URLParams()
			.set(\"pn\", \"1\") // Unknown param
			.set(\"ps\", \"1\") // Limit, Range = 1..12
			.set(\"productTypeId\", String(game.ID))
			.set(\"sex\", selectedSex)
			.toString()
	});

	if (statusCode !== 200) {
		throw new sb.errors.APIError({
			apiName: \"EgirlAPI\",
			statusCode
		});
	}

	if (!data.content || data.content.length === 0) {
		return {
			success: false,
			reply: \"No eligible profiles found!\"
		};
	}

	const ttsData = sb.Command.get(\"tts\").data;
	const {
		serveNum,
		recommendNum,
		userName,
		sex,
		languageName,
		introductionText,
		introductionSpeech,
		price
	} = data.content[0];

	if (context.channel?.ID === 38 && sb.Config.get(\"TTS_ENABLED\") && !ttsData.pending) {
		ttsData.pending = true;

		await sb.LocalRequest.playSpecialAudio({
			url: introductionSpeech,
			volume: sb.Config.get(\"TTS_VOLUME\"),
			limit: 20_000
		});

		ttsData.pending = false;
	}

	let type = \"(unspecified)\";
	if (sex === 0) {
		type =  \"(M)\";
	}
	else if (sex === 1) {
		type =  \"(F)\";
	}
	
	const revenue = (serveNum > 0)
		? `Total revenue: $${(serveNum * price) / 100}`
		: \"\";
	const language = (languageName)
		? `They speak ${languageName}.`
		: \"\";

	return {
		reply: `${userName} ${type} plays ${game.name} for $${price / 100}: ${introductionText} ${language} ${revenue}`
	};
})',
		NULL,
		'async (prefix) => {
	const row = await sb.Query.getRow(\"chat_data\", \"Command\");
	await row.load(208);
	
	const games = eval(row.values.Static_Data).games
		.map(i => `<li><code>${i.name}</code></li>`)
		.sort()
		.join(\"\");

	return [
		`Fetches a random description of a user profile from <a target=\"_blank\" href=\"egirl.gg\">egirl.gg</a>.`,
		`If this command is executed in Supinic\'s channel and TTS is on, the user introduction audio will be played.`,
		\"\",

		`<code>${prefix}ForeverAlone</code>`,
		\"Random user, female only\",
		\"\",

		`<code>${prefix}ForeverAlone sex:(male/female)</code>`,
		\"Random user, specified sex only\",
		\"\",

		`<code>${prefix}ForeverAlone game:(game)</code>`,
		\"Random user, selected game only. Only uses the first word of the game you provide.\",
		`List of games: <ul>${games}</ul>`
	];
}'
	)