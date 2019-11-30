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
		77,
		'randommeme',
		'[\"rm\"]',
		'Posts a random reddit meme. Powered by Meme API by @R3l3ntl3ss.',
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
		'async (extra, ...subreddits) => {
	let target = [\"dankmemes\", \"memes\", \"pewdiepiesubmissions\",  \"okbuddyretard\"];
	if (subreddits.length > 0) {
		const allowedSubreddits = sb.Config.get(\"RANDOM_MEME_SUBREDDITS\");
		if (subreddits.some(i => !allowedSubreddits.includes(i))) {
			return {
				reply: \"The following subreddit(s) are not available on Twitch: \" + subreddits.filter(i => !allowedSubreddits.includes(i))
			};
		}
		target = subreddits;
	}

	const url = \"https://meme-api.herokuapp.com/gimme/\" + target.join(\"+\");
	try {
		const data = JSON.parse(await sb.Utils.request(url));
		return { reply: data.title + \": \" + data.url };
	}
	catch (e) {
		console.warn(\"random meme\", e);
		return  { reply: \"API not available!\" };
	}
}',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async (extra, ...subreddits) => {
	let target = [\"dankmemes\", \"memes\", \"pewdiepiesubmissions\",  \"okbuddyretard\"];
	if (subreddits.length > 0) {
		const allowedSubreddits = sb.Config.get(\"RANDOM_MEME_SUBREDDITS\");
		if (subreddits.some(i => !allowedSubreddits.includes(i))) {
			return {
				reply: \"The following subreddit(s) are not available on Twitch: \" + subreddits.filter(i => !allowedSubreddits.includes(i))
			};
		}
		target = subreddits;
	}

	const url = \"https://meme-api.herokuapp.com/gimme/\" + target.join(\"+\");
	try {
		const data = JSON.parse(await sb.Utils.request(url));
		return { reply: data.title + \": \" + data.url };
	}
	catch (e) {
		console.warn(\"random meme\", e);
		return  { reply: \"API not available!\" };
	}
}'