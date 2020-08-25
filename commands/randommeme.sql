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
		77,
		'randommeme',
		'[\"rm\"]',
		'mention,pipe',
		'If no parameters are provided, posts a random reddit meme. If you provide a subreddit, a post will be chosen randomly. NSFW subreddits and posts are only available on NSFW Discord channels!',
		15000,
		NULL,
		'(() => {
	const expiration = 3_600_000; // 1 hour
	this.data.subreddits = {};

	class Subreddit {
		#name;
		#error = null;
		#errorMessage = null;
		#exists = false;
		#reason = null;
		#quarantine = null;
		#nsfw = null;
		#expiration = -Infinity;
		posts = [];
		repeatedPosts = [];

		constructor (meta) {
			this.#errorMessage = meta.message ?? null;
			this.#error = meta.error ?? null;
			this.#reason = meta.reason ?? null;

			if (meta.data && typeof meta.data.dist === \"undefined\") {
				const { data } = meta;
				this.#name = data.display_name;
				this.#exists = (!data.children || data.children !== 0);
				this.#quarantine = Boolean(data.quarantine);
				this.#nsfw = Boolean(data.over_18);
			}
			else {
				this.#exists = false;
				this.#expiration = Infinity;
			}
		}

		setExpiration () {
			this.#expiration = new sb.Date().addMilliseconds(expiration);
		}

		get expiration () { return this.#expiration; }
		get error () { return this.#error; }
		get exists () { return this.#exists; }
		get name () { return this.#name; }
		get nsfw () { return this.#nsfw; }
		get quarantine () { return this.#quarantine; }
		get reason () { return this.#reason; }
	}

	class RedditPost {
		#author;
		#created;
		#id;
		#title;
		#url;

		#isTextPost = false;
		#nsfw = false;
		#stickied = false;

		#score = 0;

		constructor (data) {
			this.#author = data.author;
			this.#created = new sb.Date(data.created_utc * 1000);
			this.#id = data.id;
			this.#title = data.title;
			this.#url = data.url;

			this.#isTextPost = Boolean(data.selftext && data.selftext_html);
			this.#nsfw = Boolean(data.over_18);
			this.#stickied = Boolean(data.stickied);

			this.#score = data.ups ?? 0;
		}

		get id () { return this.#id; }
		get nsfw () { return this.#nsfw; }
		get stickied () { return this.#stickied; }
		get isTextPost () { return this.#isTextPost; }
		get url () { return this.#url; }

		get posted () {
			return sb.Utils.timeDelta(this.#created);
		}

		toString () {
			return `${this.#title} ${this.#url} (Score: ${this.#score}, posted ${this.posted})`;
		}
	}

	return {
		expiration,
		RedditPost,
		Subreddit,

		banned: [
			\"bigpenis\",
			\"cockcourt\",
			\"cosplaygirls\",
			\"moobs\",
			\"fatasses\",
			\"feetpics\",
			\"foot\",
			\"instagrammodels\",
			\"russianbabes\"
		],
		defaultMemeSubreddits: [
			\"okbuddyretard\",
			\"memes\",
			\"dankmemes\",
			\"pewdiepiesubmissions\"
		]
	};
})()
',
		'(async function randomMeme (context, ...args) {
	let linkOnly = false;
	for (let i = args.length - 1; i >= 0; i--) {
		const token = args[i];
		if (token.startsWith(\"linkOnly:\")) {
			linkOnly = token.split(\":\")[1] === \"true\";
			args.splice(i, 1);
		}
	}

	let safeSpace = false;
	if (context.platform.Name === \"twitch\") {
		safeSpace = true;
	}
	else if (!context.channel?.NSFW && !context.privateMessage) {
		safeSpace = true;
	}

	const subreddit = (args.shift() ?? sb.Utils.randArray(this.staticData.defaultMemeSubreddits)).toLowerCase();
	if (!this.data.subreddits[subreddit]) {
		const data = await sb.Got.instances.Reddit(subreddit + \"/about.json\").json();
		this.data.subreddits[subreddit] = new this.staticData.Subreddit(data);
	}

	const forum = this.data.subreddits[subreddit];
	if (forum.error) {
		return {
			success: false,
			reply: `That subreddit is ${forum.reason}!`
		};
	}
	else if (!forum.exists) {
		return {
			success: false,
			reply: \"That subreddit does not exist!\"
		};
	}
	else if (safeSpace && (this.staticData.banned.includes(forum.name) || forum.nsfw)) {
		return {
			success: false,
			reply: \"That subreddit is flagged as 18+, and thus not safe to post here!\"
		};
	}

	if (forum.posts.length === 0 || sb.Date.now() > forum.expiration) {
		const { data } = await sb.Got.instances.Reddit(subreddit + \"/hot.json\").json();

		forum.setExpiration();
		forum.posts = data.children.map(i => new this.staticData.RedditPost(i.data));
	}

	const { posts, repeatedPosts } = forum;
	const validPosts = posts.filter(i => (
		(!safeSpace || !i.nsfw)
		&& !i.stickied
		&& !i.isSelftext
		&& !i.isTextPost
		&& !repeatedPosts.includes(i.id)
	));

	const post = sb.Utils.randArray(validPosts);
	if (!post) {
		return {
			success: false,
			reply: \"No suitable posts found!\"
		}
	}
	else {
		if ((this.staticData.banned.includes(forum.name) || post.nsfw) && context.append.pipe) {
			return {
				success: false,
				reason: \"pipe-nsfw\"
			};
		}
		else if (linkOnly) {
			return {
				reply: post.url
			};
		}

		// Add the currently used post ID at the beginning of the array
		repeatedPosts.unshift(post.id);
		// And then splice off everything over the length of 3.
		repeatedPosts.splice(3);

		const symbol = (forum.quarantine) ? \"⚠\" : \"\";
		return {
			reply: `${symbol} ${post}`
		}
	}
})',
		NULL,
		'supinic/supibot-sql'
	)