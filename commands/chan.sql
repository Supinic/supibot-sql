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
		204,
		'chan',
		NULL,
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
		0,
		0,
		'(async function chan (context, identifier) {
	if (!context.channel?.NSFW) {
		return {
			reply: \"This command can currently only be used in NSFW channels!\"
		};
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
	if (identifier) {
		identifier = identifier.toLowerCase().replace(/\\//g, \"\");
		board = this.data.boards.find(i => i.name === identifier);
		if (!board) {
			return {
				reply: \"Couldn\'t match your board! Please only use their abbreviations.\"
			};
		}
	}
	else {
		board = sb.Utils.randArray(this.data.boards);
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
				content: sb.Utils.fixHTML(`${i.sub ?? \"\"}${i.com ?? \"\"}`),
				modified: new sb.Date(i.last_modified),
				created: new sb.Date(i.tim),
				posts: [],
				postsExpiration: 0
			}));

		board.postsExpiration = new sb.Date().addHours(1).valueOf();
	}

	const thread = sb.Utils.randArray(board.threads);
	if (thread.posts.length === 0 || thread.postsExpiration < now) {
		const data = await sb.Got(`https://a.4cdn.org/${board.name}/thread/${thread.ID}.json`).json();
		thread.posts = data.posts.map(i => ({
			ID: i.no,
			author: i.name,
			content: sb.Utils.fixHTML(sb.Utils.removeHTML(i.com ?? \"\")),
			created: new sb.Date(i.tim),
			file: (typeof i.filename !== \"undefined\")
				? `https://i.4cdn.org/${board.name}/${i.tim}${i.ext}`
				: null
		}));

		thread.postsExpiration = new sb.Date().addMinutes(5).valueOf();
	}

	const eligiblePosts = thread.posts.filter(i => i.file);
	const post = sb.Utils.randArray(eligiblePosts);
	return {
		reply: `${post.file}`
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function chan (context, identifier) {
	if (!context.channel?.NSFW) {
		return {
			reply: \"This command can currently only be used in NSFW channels!\"
		};
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
	if (identifier) {
		identifier = identifier.toLowerCase().replace(/\\//g, \"\");
		board = this.data.boards.find(i => i.name === identifier);
		if (!board) {
			return {
				reply: \"Couldn\'t match your board! Please only use their abbreviations.\"
			};
		}
	}
	else {
		board = sb.Utils.randArray(this.data.boards);
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
				content: sb.Utils.fixHTML(`${i.sub ?? \"\"}${i.com ?? \"\"}`),
				modified: new sb.Date(i.last_modified),
				created: new sb.Date(i.tim),
				posts: [],
				postsExpiration: 0
			}));

		board.postsExpiration = new sb.Date().addHours(1).valueOf();
	}

	const thread = sb.Utils.randArray(board.threads);
	if (thread.posts.length === 0 || thread.postsExpiration < now) {
		const data = await sb.Got(`https://a.4cdn.org/${board.name}/thread/${thread.ID}.json`).json();
		thread.posts = data.posts.map(i => ({
			ID: i.no,
			author: i.name,
			content: sb.Utils.fixHTML(sb.Utils.removeHTML(i.com ?? \"\")),
			created: new sb.Date(i.tim),
			file: (typeof i.filename !== \"undefined\")
				? `https://i.4cdn.org/${board.name}/${i.tim}${i.ext}`
				: null
		}));

		thread.postsExpiration = new sb.Date().addMinutes(5).valueOf();
	}

	const eligiblePosts = thread.posts.filter(i => i.file);
	const post = sb.Utils.randArray(eligiblePosts);
	return {
		reply: `${post.file}`
	};
})'