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
		'(async function randomMeme (context, subreddit) {
	if (!subreddit) {
		subreddit = sb.Utils.randArray([\"dankmemes\", \"memes\", \"pewdiepiesubmissions\"]);
	}

	subreddit = subreddit.toLowerCase();

	const safeSpace = Boolean(!context.privateMessage && !context.channel.NSFW);
	const check = JSON.parse(await sb.Utils.request({
		uri: `https://www.reddit.com/r/${subreddit}/about.json`,
		headers: {
			\"Cookie\": \"_options={%22pref_quarantine_optin%22:true};\"
		}
	}));

	if (!check) {
		return {
			reply: \"No data obtained...\"
		};
	}
	else if (check.error === 403) {
		return {
			reply: \"That subreddit is \" + check.reason + \"!\"
		};
	}
	else if (!check.data || (Array.isArray(check.data.children) && check.data.children.length === 0)) {
		return {
			reply: \"That subreddit does not exist!\"
		};
	}
	else if (check.data.over18 && safeSpace) {
		return {
			reply: \"That subreddit is flagged as 18+, and thus not safe to post here!\"
		};
	}

	const posts = JSON.parse(await sb.Utils.request({
		uri: `https://www.reddit.com/r/${subreddit}/hot.json`,	
		headers: {
			\"Cookie\": \"_options={%22pref_quarantine_optin%22:true};\"
		}
	}));

	const children = (safeSpace)
		? posts.data.children.filter(i => !i.over_18)
		: posts.data.children;
	
	const quarantine = (check.data.quarantine) ? \"⚠\" : \"\";
	const post = sb.Utils.randArray(children);
	if (!post) {
		return {
			reply: \"No suitable posts found!\"
		}
	}
	else {
		return {
			reply: `${quarantine} ${post.data.title} ${post.data.url}`
		}
	}
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function randomMeme (context, subreddit) {
	if (!subreddit) {
		subreddit = sb.Utils.randArray([\"dankmemes\", \"memes\", \"pewdiepiesubmissions\"]);
	}

	subreddit = subreddit.toLowerCase();

	const safeSpace = Boolean(!context.privateMessage && !context.channel.NSFW);
	const check = JSON.parse(await sb.Utils.request({
		uri: `https://www.reddit.com/r/${subreddit}/about.json`,
		headers: {
			\"Cookie\": \"_options={%22pref_quarantine_optin%22:true};\"
		}
	}));

	if (!check) {
		return {
			reply: \"No data obtained...\"
		};
	}
	else if (check.error === 403) {
		return {
			reply: \"That subreddit is \" + check.reason + \"!\"
		};
	}
	else if (!check.data || (Array.isArray(check.data.children) && check.data.children.length === 0)) {
		return {
			reply: \"That subreddit does not exist!\"
		};
	}
	else if (check.data.over18 && safeSpace) {
		return {
			reply: \"That subreddit is flagged as 18+, and thus not safe to post here!\"
		};
	}

	const posts = JSON.parse(await sb.Utils.request({
		uri: `https://www.reddit.com/r/${subreddit}/hot.json`,	
		headers: {
			\"Cookie\": \"_options={%22pref_quarantine_optin%22:true};\"
		}
	}));

	const children = (safeSpace)
		? posts.data.children.filter(i => !i.over_18)
		: posts.data.children;
	
	const quarantine = (check.data.quarantine) ? \"⚠\" : \"\";
	const post = sb.Utils.randArray(children);
	if (!post) {
		return {
			reply: \"No suitable posts found!\"
		}
	}
	else {
		return {
			reply: `${quarantine} ${post.data.title} ${post.data.url}`
		}
	}
})'