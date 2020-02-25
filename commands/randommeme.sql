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
		'If no parameters are provided, posts a random reddit meme. If you provide a subreddit, a post will be chosen randomly. NSFW subreddits and posts are only available on NSFW Discord channels!',
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

	if (!this.data[subreddit]) {
		this.data[subreddit] = await sb.Got.instances.Reddit(subreddit + \"/about.json\").json();
	}

	const check = this.data[subreddit];
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
	
	const { data } = await sb.Got.instances.Reddit(subreddit + \"/hot.json\").json();
	const children = data.children.filter(i => (
		(!safeSpace || !i.data.over_18) && !i.data.selftext && !i.data.selftext_html)
	);

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

	if (!this.data[subreddit]) {
		this.data[subreddit] = await sb.Got.instances.Reddit(subreddit + \"/about.json\").json();
	}

	const check = this.data[subreddit];
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
	
	const { data } = await sb.Got.instances.Reddit(subreddit + \"/hot.json\").json();
	const children = data.children.filter(i => (
		(!safeSpace || !i.data.over_18) && !i.data.selftext && !i.data.selftext_html)
	);

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