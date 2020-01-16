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

	const banned = [\"moobs\"];
	const safeSpace = Boolean(!context.privateMessage && !context.channel.NSFW);
	if (banned.includes(subreddit)) {
		return {
			reply: \"That subreddit has been banned from viewing!\"
		};
	}

	let check = null;
	if (context.command.data[subreddit]) {
		check = context.command.data[subreddit];
	}
	else {
		check = JSON.parse(await sb.Utils.request({
			uri: `https://www.reddit.com/r/${subreddit}/about.json`,
			headers: {
				\"Cookie\": \"_options={%22pref_quarantine_optin%22:true};\"
			}
		}));
	}

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

	if (!context.command.data[subreddit]) {
		context.command.data[subreddit] = {
			error: check.error ?? null,
			data: {
				over18: check.data?.over18,
				children: check.data?.children,
				quarantine: check.data?.quarantine
			}
		};
	}

	const posts = JSON.parse(await sb.Utils.request({
		uri: `https://www.reddit.com/r/${subreddit}/hot.json`,	
		headers: {
			\"Cookie\": \"_options={%22pref_quarantine_optin%22:true};\"
		}
	}));

//	console.log(posts);

	const children = posts.data.children.filter(i => (!safeSpace || !i.over_18) && !i.selftext);	
	const quarantine = (check.data.quarantine) ? \"⚠\" : \"\";
	const post = sb.Utils.randArray(children);
	if (!post) {
		return {
			reply: \"No suitable posts found!\"
		}
	}
	else {
		const delta = sb.Utils.timeDelta(post.data.created_utc * 1000);
		return {
			reply: `${quarantine} ${post.data.title} ${post.data.url} (posted ${delta})`
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

	const banned = [\"moobs\"];
	const safeSpace = Boolean(!context.privateMessage && !context.channel.NSFW);
	if (banned.includes(subreddit)) {
		return {
			reply: \"That subreddit has been banned from viewing!\"
		};
	}

	let check = null;
	if (context.command.data[subreddit]) {
		check = context.command.data[subreddit];
	}
	else {
		check = JSON.parse(await sb.Utils.request({
			uri: `https://www.reddit.com/r/${subreddit}/about.json`,
			headers: {
				\"Cookie\": \"_options={%22pref_quarantine_optin%22:true};\"
			}
		}));
	}

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

	if (!context.command.data[subreddit]) {
		context.command.data[subreddit] = {
			error: check.error ?? null,
			data: {
				over18: check.data?.over18,
				children: check.data?.children,
				quarantine: check.data?.quarantine
			}
		};
	}

	const posts = JSON.parse(await sb.Utils.request({
		uri: `https://www.reddit.com/r/${subreddit}/hot.json`,	
		headers: {
			\"Cookie\": \"_options={%22pref_quarantine_optin%22:true};\"
		}
	}));

//	console.log(posts);

	const children = posts.data.children.filter(i => (!safeSpace || !i.over_18) && !i.selftext);	
	const quarantine = (check.data.quarantine) ? \"⚠\" : \"\";
	const post = sb.Utils.randArray(children);
	if (!post) {
		return {
			reply: \"No suitable posts found!\"
		}
	}
	else {
		const delta = sb.Utils.timeDelta(post.data.created_utc * 1000);
		return {
			reply: `${quarantine} ${post.data.title} ${post.data.url} (posted ${delta})`
		}
	}
})'