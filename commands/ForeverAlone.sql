INSERT INTO
	`chat_data`.`Command`
	(
		ID,
		Name,
		Aliases,
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
		'({
	games: [
		{
			\"ID\": 4,
			\"name\": \"League of Legends\",
			\"gameID\": 4637
		},
		{
			\"ID\": 7,
			\"name\": \"Overwatch\",
			\"gameID\": 1184
		},
		{
			\"ID\": 6,
			\"name\": \"Minecraft\",
			\"gameID\": 858
		},
		{
			\"ID\": 5,
			\"name\": \"Fortnite\",
			\"gameID\": 559
		},
		{
			\"ID\": 1,
			\"name\": \"CSGO\",
			\"gameID\": 555
		},
		{
			\"ID\": 18,
			\"name\": \"Call of duty\",
			\"gameID\": 399
		},
		{
			\"ID\": 12,
			\"name\": \"Apex Legends\",
			\"gameID\": 347
		},
		{
			\"ID\": 14,
			\"name\": \"Dead by Daylight\",
			\"gameID\": 230
		},
		{
			\"ID\": 13,
			\"name\": \"VR chat\",
			\"gameID\": 207
		},
		{
			\"ID\": 11,
			\"name\": \"World of Warcraft\",
			\"gameID\": 178
		},
		{
			\"ID\": 17,
			\"name\": \"Roblox\",
			\"gameID\": 155
		},
		{
			\"ID\": 2,
			\"name\": \"DOTA2\",
			\"gameID\": 117
		},
		{
			\"ID\": 16,
			\"name\": \"Smash bro\",
			\"gameID\": 105
		},
		{
			\"ID\": 15,
			\"name\": \"Rocket league\",
			\"gameID\": 94
		},
		{
			\"ID\": 3,
			\"name\": \"PUBG\",
			\"gameID\": 60
		},
		{
			\"ID\": 8,
			\"name\": \"Hearth Stone\",
			\"gameID\": 58
		},
		{
			\"ID\": 10,
			\"name\": \"Heroes of the Storm\",
			\"gameID\": 56
		},
		{
			\"ID\": 9,
			\"name\": \"Gwent\",
			\"gameID\": 12
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

	const data = await sb.Got.instances.FakeAgent({
		method: \"POST\",
		url: \"https://www.egirl.gg/api/web/home/random-recommend\",
		searchParams: new sb.URLParams()
			.set(\"pn\", \"1\") // Unknown param
			.set(\"ps\", \"1\") // Limit, Range = 1..12
			.set(\"productTypeId\", String(game.ID))
			.set(\"sex\", selectedSex)
			.toString()
	}).json();

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
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function something (context, ...args) {
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

	const data = await sb.Got.instances.FakeAgent({
		method: \"POST\",
		url: \"https://www.egirl.gg/api/web/home/random-recommend\",
		searchParams: new sb.URLParams()
			.set(\"pn\", \"1\") // Unknown param
			.set(\"ps\", \"1\") // Limit, Range = 1..12
			.set(\"productTypeId\", String(game.ID))
			.set(\"sex\", selectedSex)
			.toString()
	}).json();

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
})'