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
		170,
		'texttransform',
		'[\"tt\"]',
		'Transforms provided text into one of provided types, such as \"vaporwave\", for example.',
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
		NULL,
		'(async function textTransform (context, type, ...args) {
	if (!type) {
		return {
			reply: \"No type provided! Check the command\'s help for more info.\"
		};
	}
	else if (args.length === 0) {
		return {
			reply: \"No message provided!\"
		};
	}

	let resultType = null;
	let map = null;
	let message = args.join(\" \");
	let additionalTransform = null;

	switch (type) {
		case \"3Head\":
			resultType = \"translate\";
			map = sb.Config.get(\"TRANSLATION_DATA_COCKNEY\");
			break;

		case \"bubble\":
			resultType = \"map\";
			map = sb.Config.get(\"CHARACTER_MAP_BUBBLE\");
			break;

		case \"cap\":
		case \"capitalize\":
			resultType = \"replace\";
			message = message.split(\" \").map(i => sb.Utils.capitalize(i)).join(\" \");
			break;

		case \"fancy\":
			resultType = \"map\";
			map = sb.Config.get(\"CHARACTER_MAP_FANCY\");
			break;

		case \"KKona\":
			resultType = \"translate\";
			map = sb.Config.get(\"TRANSLATION_DATA_COWBOY\");
			break;

		case \"KKrikey\":
			resultType = \"translate\";
			map = sb.Config.get(\"TRANSLATION_DATA_STRAYA\");
			break;

		case \"lc\":
		case \"lower\":
		case \"lowercase\":
			resultType = \"replace\";
			message = message.toLowerCase();
			break;

		case \"leet\":
		case \"l337\":
		case \"1337\":
			resultType = \"map\";
			map = sb.Config.get(\"CHARACTER_MAP_LEET\");
			break;

		case \"medieval\":
			resultType = \"map\";
			map = sb.Config.get(\"CHARACTER_MAP_MEDIVEAL\");
			break;

		case \"monkaOMEGA\":
			resultType = \"replace\";
			message = message.replace(/[oOｏＯоО]/g, \" monkaOMEGA \");
			break;

		case \"OMEGALUL\":
			resultType = \"replace\";
			message = message.replace(/[oOｏＯоО]/g, \" OMEGALUL \");
			break;

		case \"owo\":
		case \"owoify\": {
			resultType = \"replace\";
			const faces = [\"(・`ω´・)\", \";;w;;\", \"owo\", \"UwU\", \">w<\", \"^w^\"];
			message = message.replace(/(?:[rl])/g, \"w\")
				.replace(/(?:[RL])/g, \"W\")
				.replace(/n([aeiou])/g, \"ny$1\")
				.replace(/N([aeiou])/g, \"Ny$1\")
				.replace(/N([AEIOU])/g, \"Ny$1\")
				.replace(/ove/g, \"uv\")
				.replace(/!+/g, \" \" + sb.Utils.randArray(faces) + \" \");

			break;
		}

		case \"runes\":
		case \"runic\":
			resultType = \"map\";
			message = message.toLowerCase();
			map = sb.Config.get(\"CHARACTER_MAP_RUNES\");
			break;

		case \"smol\":
		case \"super\":
		case \"superscript\":
			resultType = \"map\";
			map = sb.Config.get(\"CHARACTER_MAP_SUPERSCRIPT\");
			break;

		case \"uc\":
		case \"upper\":
		case \"uppercase\":
			resultType = \"replace\";
			message = message.toUpperCase();
			break;

		case \"ud\":
		case \"upsidedown\":
		case \"flipped\":
			resultType = \"map\";
			map = sb.Config.get(\"CHARACTER_MAP_FLIPPED\");
			additionalTransform = (string) => string.split(\"\").reverse().join(\"\");
			break;

		case \"vw\":
		case \"vapor\":
		case \"vaporwave\":
			resultType = \"map\";
			map = sb.Config.get(\"CHARACTER_MAP_VAPORWAVE\");
			break;

		default: return {
			reply: \"Invalid type provided! Check the command\'s help for more info.\"
		};
	}

	let result = null;
	if (resultType === \"map\") {
		result = message.split(\"\").map(i => map[i] || i).join(\"\");
	}
	else if (map && resultType === \"translate\") {
		result = message;
		for (const [from, to] of map.phrasesWords) {
			const r = new RegExp(\"\\\\b\" + from + \"\\\\b\", \"gi\");
			result = result.replace(r, \"_\" + to + \"_\");
		}

		for (const [from, to] of map.prefixes) {
			const r = new RegExp(\"\\\\b\" + from, \"gi\");
			result = result.replace(r, to);
		}

		for (const [from, to] of map.suffixes) {
			const r = new RegExp(from + \"\\\\b\", \"gi\");
			result = result.replace(r, to);
		}

		for (const [from, to] of map.intrawords) {
			const r = new RegExp(from, \"gi\");
			result = result.replace(r, to);
		}

		result = result.trim().replace(/_/g, \"\");

		if (map.endings && /[).?!]$/.test(result)) {
			result += \" \" + sb.Utils.randArray(map.endings);
		}
	}
	else if (resultType === \"replace\") {
		result = message;
	}

	if (typeof additionalTransform === \"function\") {
		result = additionalTransform(result);
	}

	if (!result) {
		return {
			reply: \"No result has been created?!\"
		};
	}

	return {
		reply: result,
		cooldown: {
			length: (context.append.pipe) ? null : this.Cooldown
		}
	};
})',
		NULL,
		'async (prefix) => [
	\"Transforms given text to different styles, according to type provided.\",
	\"Types, their aliases and short-hands are listed below, separeted by slash\",
	\"\",

	`<code>${prefix}tt 3Head This is a sample message.</code>`,
	`dis is a sample message.`,
	``,

	`<code>${prefix}tt cap/capitalize This is a sample message.</code>`,
	`This Is A Sample Message.`,
	``,

	`<code>${prefix}tt fancy This is a test</code>`,
	 `𝓣𝓱𝓲𝓼 𝓲𝓼 𝓪 𝓽𝓮𝓼𝓽`,
	``,

	`<code>${prefix}tt KKona Let\'s mine some gold and buy some guns.</code>`,
	`done let\'s maahn sum color an buy sum barkin\' irons.`,
	``,

	`<code>${prefix}tt KKrikey KKrikey Let\'s buy a beer at the gas station.</code>`,
	`Let\'s buy a cold one at the fuckin\' servo. Too right, mate.`,
	``,
	
	`<code>${prefix}tt lc/lower/lowercase This is a test</code>`,
	`this is a test`,
	``,
	
	`<code>${prefix}tt leet/1337/l337 This is a test</code>`,
	`7hi5 i5 4 7357`,
	``,
	
	`<code>${prefix}tt medieval This is a test</code>`,
	`𝕿𝖍𝖎𝖘 𝖎𝖘 𝖆 𝖙𝖊𝖘𝖙`,
	``,
	
	`<code>${prefix}tt monkaOMEGA Hello</code>`,
	`Hell monkaOMEGA`,
	``,
	
	`<code>${prefix}tt OMEGALUL Hello</code>`,
	`Hell OMEGALUL`,
	``,
	
	`<code>${prefix}tt owo/owoify There he is. The ogrelord. Shrek!</code>`,
	`Thewe he is. The ogwewowd. Shwek ^w^`,
	``,

	`<code>${prefix}tt runes/runic Sample sentence</code>`,
	`ᛋᚪᛗᛈᛚᛖ ᛋᛖᚾᛏᛖᚾᚳᛖ`,
	``,
	
	`<code>${prefix}tt smol/super/superscript My dream is a chat full of smol spam</code>`,
	`ᴹʸ ᵈʳᵉᵃᵐ ⁱˢ ᵃ ᶜʰᵃᵗ ᶠᵘˡˡ ᵒᶠ ˢᵐᵒˡ ˢᵖᵃᵐ`,
	``,

	`<code>${prefix}tt uc/upper/uppercase This is a test</code>`,
	`THIS IS A TEST`,
	``,

	`<code>${prefix}tt ud/upsidedown/flipped Sample sentence.</code>`,
	`.ǝɔuǝʇuǝs ǝlpɯɐS`,
	``,
	
	`<code>${prefix}tt vw/vaporwave This is a test</code>`,
	`Ｔｈｉｓ ｉｓ ａ ｔｅｓｔ`,
	``
]'
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function textTransform (context, type, ...args) {
	if (!type) {
		return {
			reply: \"No type provided! Check the command\'s help for more info.\"
		};
	}
	else if (args.length === 0) {
		return {
			reply: \"No message provided!\"
		};
	}

	let resultType = null;
	let map = null;
	let message = args.join(\" \");
	let additionalTransform = null;

	switch (type) {
		case \"3Head\":
			resultType = \"translate\";
			map = sb.Config.get(\"TRANSLATION_DATA_COCKNEY\");
			break;

		case \"bubble\":
			resultType = \"map\";
			map = sb.Config.get(\"CHARACTER_MAP_BUBBLE\");
			break;

		case \"cap\":
		case \"capitalize\":
			resultType = \"replace\";
			message = message.split(\" \").map(i => sb.Utils.capitalize(i)).join(\" \");
			break;

		case \"fancy\":
			resultType = \"map\";
			map = sb.Config.get(\"CHARACTER_MAP_FANCY\");
			break;

		case \"KKona\":
			resultType = \"translate\";
			map = sb.Config.get(\"TRANSLATION_DATA_COWBOY\");
			break;

		case \"KKrikey\":
			resultType = \"translate\";
			map = sb.Config.get(\"TRANSLATION_DATA_STRAYA\");
			break;

		case \"lc\":
		case \"lower\":
		case \"lowercase\":
			resultType = \"replace\";
			message = message.toLowerCase();
			break;

		case \"leet\":
		case \"l337\":
		case \"1337\":
			resultType = \"map\";
			map = sb.Config.get(\"CHARACTER_MAP_LEET\");
			break;

		case \"medieval\":
			resultType = \"map\";
			map = sb.Config.get(\"CHARACTER_MAP_MEDIVEAL\");
			break;

		case \"monkaOMEGA\":
			resultType = \"replace\";
			message = message.replace(/[oOｏＯоО]/g, \" monkaOMEGA \");
			break;

		case \"OMEGALUL\":
			resultType = \"replace\";
			message = message.replace(/[oOｏＯоО]/g, \" OMEGALUL \");
			break;

		case \"owo\":
		case \"owoify\": {
			resultType = \"replace\";
			const faces = [\"(・`ω´・)\", \";;w;;\", \"owo\", \"UwU\", \">w<\", \"^w^\"];
			message = message.replace(/(?:[rl])/g, \"w\")
				.replace(/(?:[RL])/g, \"W\")
				.replace(/n([aeiou])/g, \"ny$1\")
				.replace(/N([aeiou])/g, \"Ny$1\")
				.replace(/N([AEIOU])/g, \"Ny$1\")
				.replace(/ove/g, \"uv\")
				.replace(/!+/g, \" \" + sb.Utils.randArray(faces) + \" \");

			break;
		}

		case \"runes\":
		case \"runic\":
			resultType = \"map\";
			message = message.toLowerCase();
			map = sb.Config.get(\"CHARACTER_MAP_RUNES\");
			break;

		case \"smol\":
		case \"super\":
		case \"superscript\":
			resultType = \"map\";
			map = sb.Config.get(\"CHARACTER_MAP_SUPERSCRIPT\");
			break;

		case \"uc\":
		case \"upper\":
		case \"uppercase\":
			resultType = \"replace\";
			message = message.toUpperCase();
			break;

		case \"ud\":
		case \"upsidedown\":
		case \"flipped\":
			resultType = \"map\";
			map = sb.Config.get(\"CHARACTER_MAP_FLIPPED\");
			additionalTransform = (string) => string.split(\"\").reverse().join(\"\");
			break;

		case \"vw\":
		case \"vapor\":
		case \"vaporwave\":
			resultType = \"map\";
			map = sb.Config.get(\"CHARACTER_MAP_VAPORWAVE\");
			break;

		default: return {
			reply: \"Invalid type provided! Check the command\'s help for more info.\"
		};
	}

	let result = null;
	if (resultType === \"map\") {
		result = message.split(\"\").map(i => map[i] || i).join(\"\");
	}
	else if (map && resultType === \"translate\") {
		result = message;
		for (const [from, to] of map.phrasesWords) {
			const r = new RegExp(\"\\\\b\" + from + \"\\\\b\", \"gi\");
			result = result.replace(r, \"_\" + to + \"_\");
		}

		for (const [from, to] of map.prefixes) {
			const r = new RegExp(\"\\\\b\" + from, \"gi\");
			result = result.replace(r, to);
		}

		for (const [from, to] of map.suffixes) {
			const r = new RegExp(from + \"\\\\b\", \"gi\");
			result = result.replace(r, to);
		}

		for (const [from, to] of map.intrawords) {
			const r = new RegExp(from, \"gi\");
			result = result.replace(r, to);
		}

		result = result.trim().replace(/_/g, \"\");

		if (map.endings && /[).?!]$/.test(result)) {
			result += \" \" + sb.Utils.randArray(map.endings);
		}
	}
	else if (resultType === \"replace\") {
		result = message;
	}

	if (typeof additionalTransform === \"function\") {
		result = additionalTransform(result);
	}

	if (!result) {
		return {
			reply: \"No result has been created?!\"
		};
	}

	return {
		reply: result,
		cooldown: {
			length: (context.append.pipe) ? null : this.Cooldown
		}
	};
})'