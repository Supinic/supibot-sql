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
		216,
		'ocr',
		NULL,
		'mention,pipe',
		'Takes your image link and attempts to find the text in it by using OCR.',
		10000,
		NULL,
		'({
	languages: {
		ara: \"Arabic\",
		bul: \"Bulgarian\",
		chs: \"Chinese (Simplified)\",
		cht: \"Chinese (Traditional)\",
		hrv: \"Croatian\",
		cze: \"Czech\",
		dan: \"Danish\",
		dut: \"Dutch\",
		eng: \"English\",
		fin: \"Finnish\",
		fre: \"French\",
		ger: \"German\",
		gre: \"Greek\",
		hun: \"Hungarian\",
		kor: \"Korean\",
		ita: \"Italian\",
		jpn: \"Japanese\",
		pol: \"Polish\",
		por: \"Portuguese\",
		rus: \"Russian\",
		slv: \"Slovenian\",
		spa: \"Spanish\",
		swe: \"Swedish\",
		tur: \"Turkish\"
	}
})',
		'(async function ocr (context, ...args) {
	let language = \"eng\";
	for (let i = 0; i < args.length; i++) {
		const token = args[i];
		if (token.includes(\"lang:\")) {
			language = sb.Utils.languageISO.getCode(token.split(\":\")[1], \"iso6393\");
			if (!language) {
				return {
					success: false,
					reply: \"Language could not be parsed!\"
				};
			}

			args.splice(i, 1);
		}
	}

	if (language === \"chi\") {
		language = \"chs\"; // thanks for using standard codes everyone
	}

	if (!Object.keys(this.staticData.languages).includes(language)) {
		return {
			success: false,
			reply: \"Language not supported, use one from the list in the help description\",
			cooldown: 2500
		};
	}

	const link = args.shift();
	if (!link) {
		return {
			success: false,
			reply: \"No link provided!\",
			cooldown: 2500
		};
	}

	const { statusCode, body: data } = await sb.Got({
		method: \"GET\",
		responseType: \"json\",
		throwHttpErrors: false,
		url: \"https://api.ocr.space/parse/imageurl\",
		headers: {
			apikey: sb.Config.get(\"API_OCR_SPACE\")
		},
		searchParams: new sb.URLParams()
			.set(\"url\", link)
			.set(\"language\", language)
			.set(\"scale\", \"true\")
			.set(\"isTable\", \"true\")
			.set(\"OCREngine\", \"1\")
			.set(\"isOverlayRequired\", \"false\")
			.toString()
	});

	if (statusCode !== 200 || data?.OCRExitCode !== 1) {
		return {
			success: false,
			reply: (data?.ErrorMessage) 
				? data.ErrorMessage.join(\" \")
				: data
		};
	}

	const result = data.ParsedResults[0].ParsedText;
	return {
		reply: (result.length === 0)
			? \"No text found.\"
			: result
	};
})',
		'async (prefix, values) => {
	const { languages } = values.getStaticData();
	const list = Object.entries(languages).map(([code, name]) => `<li>${name} - <code>${code}</code></li>`).join(\"\");

	return [
		\"Attempts to read a provided image with OCR, and posts the found text in chat.\",
		\"You can specify a language, and only 3-letter codes are supported, i.e. \'jpn\'.\",
		\"By default, the language is English (eng).\",
		\"\",

		`<code>${prefix}ocr <a href=\"https://i.imgur.com/FutGrGV.png\">https://i.imgur.com/FutGrGV.png</a></code>`,
		\"HELLO WORLD LOL NAM\",
		\"\",
		
		`<code>${prefix}ocr lang:jpn <a href=\"https://i.imgur.com/4iK4ZHy.png\">https://i.imgur.com/4iK4ZHy.png</a></code>`,
		\"ロ明寝マンRetweeted 蜜柑すい@mikansul・May11 ティフアに壁ドンされるだけ\",
		\"\",

		\"List of supported languages:\",
		list
	];
}',
		'supinic/supibot-sql'
	)