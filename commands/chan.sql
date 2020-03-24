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
		204,
		'chan',
		'[\"4chan\", \"textchan\", \"filechan\", \"imagechan\"]',
		'Pulls a random post from a random board, or a specified one, if you provide it.',
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
		'(async function chan (context, identifier, ...rest) {
	if (!identifier) {
		return {
			reply: \"You must specify a board name!\"
		};
	}

	const enabled = {
		content: {
			sfw: true,
			nsfw: false
		},
		file: {
			sfw: false,
			nsfw: false
		}
	};

	if (context.platform.Name === \"discord\") {
		enabled.file.sfw = true;
		enabled.content.nsfw = true;

		if (context.channel?.NSFW) {
			enabled.file.nsfw = true;
		}
	}

	let resultType = (context.channel?.NSFW)
		? \"file\"
		: \"content\";

	if (context.invocation === \"textchan\") {
		resultType = \"content\";
	}
	else if (context.invocation === \"imagechan\" || context.invocation === \"filechan\") {
		if (!enabled.file.sfw && !enabled.file.nsfw) {
			return {
				reply: \"You cannot query for images here!\"
			}
		}

		resultType = \"file\";
	}

	if (!this.data.boards) {
		const data = await sb.Got(\"https://api.4chan.org/boards.json\").json();
		this.data.boards = data.boards.map(i => ({
			name: i.board,
			title: i.title,
			nsfw: !i.ws_board,
			threads: [],
			threadsExpiration: 0
		}));
	}

	let board = null;
	identifier = identifier.toLowerCase().replace(/\\//g, \"\");
	board = this.data.boards.find(i => i.name === identifier);

	if (!board) {
		return {
			reply: \"Couldn\'t match your board! Use their abbreviations only.\"
		};
	}
	else if (board.nsfw && !enabled[resultType].nsfw) {
		return {
			reply: \"You can\'t query this NSFW board for that result type here!\"
		};
	}

	if (board.nsfw && context.append.pipe) {
		return {
			success: false,
			reason: \"pipe-nsfw\"
		};
	}

	const now = sb.Date.now();
	if (board.threads.length === 0 || board.threadsExpiration < now) {
		const data = await sb.Got(`https://api.4chan.org/${board.name}/catalog.json`).json();
		board.threads = data
			.map(i => i.threads)
			.flat()
			.filter(i => !i.sticky && !i.closed && i.replies >= 5)
			.map(i => ({
				ID: i.no,
				content: sb.Utils.fixHTML(sb.Utils.removeHTML(`${i.sub ?? \"\"}${i.com ?? \"\"}`)),
				modified: new sb.Date(i.last_modified),
				created: new sb.Date(i.tim),
				posts: [],
				postsExpiration: 0
			}));

		board.threadsExpiration = new sb.Date().addHours(1).valueOf();
	}

	let thread = null;
	if (rest.length > 0) {
		const query = rest.join(\" \").toLowerCase();
		thread = sb.Utils.randArray(board.threads.filter(i => !i.dead && i.content.toLowerCase().includes(query)));

		if (!thread) {
			return {
				reply: \"No threads found for your query!\"
			};
		}
	}
	else {
		thread = sb.Utils.randArray(board.threads.filter(i => !i.dead));
	}

	if (thread.posts.length === 0 || thread.postsExpiration < now) {
		const { body: data, statusCode } = await sb.Got({
			url: `https://a.4cdn.org/${board.name}/thread/${thread.ID}.json`,
			throwHttpErrors: false,
			responseType: \"json\"
		});

		if (statusCode === 404) {
			thread.dead = true;

			return {
				reply: \"The thread has been pruned/archived! Please try again.\",
				cooldown: 5000
			};
		}

		thread.posts = data.posts.map(i => ({
			ID: i.no,
			author: i.name,
			content: sb.Utils.fixHTML(sb.Utils.removeHTML(i.com ?? \"\")),
			created: new sb.Date(i.time * 1000),
			file: (typeof i.filename !== \"undefined\")
				? `https://i.4cdn.org/${board.name}/${i.tim}${i.ext}`
				: null
		}));

		thread.postsExpiration = new sb.Date().addMinutes(10).valueOf();
	}

	const eligiblePosts = thread.posts.filter(i => i[resultType]);
	const post = sb.Utils.randArray(eligiblePosts);
	const delta = sb.Utils.timeDelta(post.created);

	if (resultType === \"file\") {
		return {
			reply: `${post.ID} (posted ${delta}): ${post.file} ${post.content}`
		};
	}
	else if (resultType === \"content\") {
		return {
			reply: `${post.ID} (posted ${delta}): ${post.content}`
		};
	}
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function chan (context, identifier, ...rest) {
	if (!identifier) {
		return {
			reply: \"You must specify a board name!\"
		};
	}

	const enabled = {
		content: {
			sfw: true,
			nsfw: false
		},
		file: {
			sfw: false,
			nsfw: false
		}
	};

	if (context.platform.Name === \"discord\") {
		enabled.file.sfw = true;
		enabled.content.nsfw = true;

		if (context.channel?.NSFW) {
			enabled.file.nsfw = true;
		}
	}

	let resultType = (context.channel?.NSFW)
		? \"file\"
		: \"content\";

	if (context.invocation === \"textchan\") {
		resultType = \"content\";
	}
	else if (context.invocation === \"imagechan\" || context.invocation === \"filechan\") {
		if (!enabled.file.sfw && !enabled.file.nsfw) {
			return {
				reply: \"You cannot query for images here!\"
			}
		}

		resultType = \"file\";
	}

	if (!this.data.boards) {
		const data = await sb.Got(\"https://api.4chan.org/boards.json\").json();
		this.data.boards = data.boards.map(i => ({
			name: i.board,
			title: i.title,
			nsfw: !i.ws_board,
			threads: [],
			threadsExpiration: 0
		}));
	}

	let board = null;
	identifier = identifier.toLowerCase().replace(/\\//g, \"\");
	board = this.data.boards.find(i => i.name === identifier);

	if (!board) {
		return {
			reply: \"Couldn\'t match your board! Use their abbreviations only.\"
		};
	}
	else if (board.nsfw && !enabled[resultType].nsfw) {
		return {
			reply: \"You can\'t query this NSFW board for that result type here!\"
		};
	}

	if (board.nsfw && context.append.pipe) {
		return {
			success: false,
			reason: \"pipe-nsfw\"
		};
	}

	const now = sb.Date.now();
	if (board.threads.length === 0 || board.threadsExpiration < now) {
		const data = await sb.Got(`https://api.4chan.org/${board.name}/catalog.json`).json();
		board.threads = data
			.map(i => i.threads)
			.flat()
			.filter(i => !i.sticky && !i.closed && i.replies >= 5)
			.map(i => ({
				ID: i.no,
				content: sb.Utils.fixHTML(sb.Utils.removeHTML(`${i.sub ?? \"\"}${i.com ?? \"\"}`)),
				modified: new sb.Date(i.last_modified),
				created: new sb.Date(i.tim),
				posts: [],
				postsExpiration: 0
			}));

		board.threadsExpiration = new sb.Date().addHours(1).valueOf();
	}

	let thread = null;
	if (rest.length > 0) {
		const query = rest.join(\" \").toLowerCase();
		thread = sb.Utils.randArray(board.threads.filter(i => !i.dead && i.content.toLowerCase().includes(query)));

		if (!thread) {
			return {
				reply: \"No threads found for your query!\"
			};
		}
	}
	else {
		thread = sb.Utils.randArray(board.threads.filter(i => !i.dead));
	}

	if (thread.posts.length === 0 || thread.postsExpiration < now) {
		const { body: data, statusCode } = await sb.Got({
			url: `https://a.4cdn.org/${board.name}/thread/${thread.ID}.json`,
			throwHttpErrors: false,
			responseType: \"json\"
		});

		if (statusCode === 404) {
			thread.dead = true;

			return {
				reply: \"The thread has been pruned/archived! Please try again.\",
				cooldown: 5000
			};
		}

		thread.posts = data.posts.map(i => ({
			ID: i.no,
			author: i.name,
			content: sb.Utils.fixHTML(sb.Utils.removeHTML(i.com ?? \"\")),
			created: new sb.Date(i.time * 1000),
			file: (typeof i.filename !== \"undefined\")
				? `https://i.4cdn.org/${board.name}/${i.tim}${i.ext}`
				: null
		}));

		thread.postsExpiration = new sb.Date().addMinutes(10).valueOf();
	}

	const eligiblePosts = thread.posts.filter(i => i[resultType]);
	const post = sb.Utils.randArray(eligiblePosts);
	const delta = sb.Utils.timeDelta(post.created);

	if (resultType === \"file\") {
		return {
			reply: `${post.ID} (posted ${delta}): ${post.file} ${post.content}`
		};
	}
	else if (resultType === \"content\") {
		return {
			reply: `${post.ID} (posted ${delta}): ${post.content}`
		};
	}
})'