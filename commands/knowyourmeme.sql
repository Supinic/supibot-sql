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
		Code,
		Examples,
		Dynamic_Description
	)
VALUES
	(
		188,
		'knowyourmeme',
		'[\"kym\"]',
		'Gets a smol description of a meme from KnowYourMeme, it\'s just the summary.',
		30000,
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
		'(async function knowYourMeme (context, ...args) {
	if (args.length === 0) {
		return {
			reply: \"No search term provided!\"
		};
	}

	const fakeAgent = \"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36\";
	const baseURL = \"https://knowyourmeme.com/\";

	const params = new sb.URLParams().set(\"q\", args.join(\" \"));
	const searchData = await sb.Utils.request({
		uri: `${baseURL}/search?${params.toString()}`,
		headers: {
			\"User-Agent\": fakeAgent
		}
	});

	const firstLink = searchData.match(/class=[\'\"]photo[\'\"] href=.(\\/meme.*?)[\'\"]/ms);
	if (!firstLink) {
		return {
			reply: \"No result found for given search term!\"
		};
	}

	const memeHTML = await sb.Utils.request({
		uri: `${baseURL}${firstLink[1]}`,
		headers: {
			\"User-Agent\": fakeAgent
		}
	});

	const memeData = memeHTML.match(/h2 id=[\'\"]about[\'\"].*?<p>(.*?)<\\/p>/ms);
	if (!memeData) {
		return {
			reply: \"No summary found for given meme!\"
		};
	}

	return {
		reply: sb.Utils.removeHTML(memeData[1])
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function knowYourMeme (context, ...args) {
	if (args.length === 0) {
		return {
			reply: \"No search term provided!\"
		};
	}

	const fakeAgent = \"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36\";
	const baseURL = \"https://knowyourmeme.com/\";

	const params = new sb.URLParams().set(\"q\", args.join(\" \"));
	const searchData = await sb.Utils.request({
		uri: `${baseURL}/search?${params.toString()}`,
		headers: {
			\"User-Agent\": fakeAgent
		}
	});

	const firstLink = searchData.match(/class=[\'\"]photo[\'\"] href=.(\\/meme.*?)[\'\"]/ms);
	if (!firstLink) {
		return {
			reply: \"No result found for given search term!\"
		};
	}

	const memeHTML = await sb.Utils.request({
		uri: `${baseURL}${firstLink[1]}`,
		headers: {
			\"User-Agent\": fakeAgent
		}
	});

	const memeData = memeHTML.match(/h2 id=[\'\"]about[\'\"].*?<p>(.*?)<\\/p>/ms);
	if (!memeData) {
		return {
			reply: \"No summary found for given meme!\"
		};
	}

	return {
		reply: sb.Utils.removeHTML(memeData[1])
	};
})'