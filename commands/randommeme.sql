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
		NULL,
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

	if (!this.data.meta) {
		this.data.meta = {};
	}
	if (!this.data.posts) {
		this.data.posts = {};
	}

	if (!this.data.meta[subreddit]) {
		this.data.meta[subreddit] = await sb.Got.instances.Reddit(subreddit + \"/about.json\").json();
	}

	const check = this.data.meta[subreddit];
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

	if (!this.data.posts[subreddit] || sb.Date.now() > this.data.posts[subreddit].expiry) {
		const { data } = await sb.Got.instances.Reddit(subreddit + \"/hot.json\").json();
		this.data.posts[subreddit] = {
			repeatedPosts: [],
			list: data.children,
			expiry: new sb.Date().addHours(1).valueOf()
		};
	}

	const { list, repeatedPosts } = this.data.posts[subreddit];
	const children = list.filter(i => (
		(!safeSpace || !i.data.over_18)
		&& !i.data.selftext
		&& !i.data.selftext_html
		&& !repeatedPosts.includes(i.data.id)
	));

	const quarantine = (check.data.quarantine) ? \"⚠\" : \"\";
	const post = sb.Utils.randArray(children);
	if (!post) {
		return {
			reply: \"No suitable posts found!\"
		}
	}
	else {
		// Add the currently used post ID at the beginning of the array
		repeatedPosts.unshift(post.data.id);
		// And then splice off everything over the length of 3.
		repeatedPosts.splice(3);

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

	if (!this.data.meta) {
		this.data.meta = {};
	}
	if (!this.data.posts) {
		this.data.posts = {};
	}

	if (!this.data.meta[subreddit]) {
		this.data.meta[subreddit] = await sb.Got.instances.Reddit(subreddit + \"/about.json\").json();
	}

	const check = this.data.meta[subreddit];
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

	if (!this.data.posts[subreddit] || sb.Date.now() > this.data.posts[subreddit].expiry) {
		const { data } = await sb.Got.instances.Reddit(subreddit + \"/hot.json\").json();
		this.data.posts[subreddit] = {
			repeatedPosts: [],
			list: data.children,
			expiry: new sb.Date().addHours(1).valueOf()
		};
	}

	const { list, repeatedPosts } = this.data.posts[subreddit];
	const children = list.filter(i => (
		(!safeSpace || !i.data.over_18)
		&& !i.data.selftext
		&& !i.data.selftext_html
		&& !repeatedPosts.includes(i.data.id)
	));

	const quarantine = (check.data.quarantine) ? \"⚠\" : \"\";
	const post = sb.Utils.randArray(children);
	if (!post) {
		return {
			reply: \"No suitable posts found!\"
		}
	}
	else {
		// Add the currently used post ID at the beginning of the array
		repeatedPosts.unshift(post.data.id);
		// And then splice off everything over the length of 3.
		repeatedPosts.splice(3);

		const delta = sb.Utils.timeDelta(post.data.created_utc * 1000);
		return {
			reply: `${quarantine} ${post.data.title} ${post.data.url} (posted ${delta})`
		}
	}
})'