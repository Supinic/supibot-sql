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
		162,
		'github',
		NULL,
		'developer,ping,pipe',
		'Posts GitHub repository links for Supibot and the website. If you add anything afterwards, a search will be executed for your query on the bot repository.',
		5000,
		NULL,
		NULL,
		'(async function github (context, ...args) { 
	const query = args.join(\"\");
	if (!query) {
		return {
			reply: sb.Utils.tag.trim `
				Supibot: https://github.com/Supinic/supibot 
				// Website: https://github.com/Supinic/supinic.com
				// Modules: https://github.com/Supinic/supi-core
				// SQL: https://github.com/Supinic/supibot-sql
			`
		};
	}

	const { items } = await sb.Got.instances.GitHub({
		url: `search/code?q=${query}+in:file+repo:supinic/supi-core+repo:supinic/supibot`
	}).json();

	const filtered = items.filter(i => i.name.endsWith(\".js\"));
	if (filtered.length === 0) {
		return {
			success: false,
			reply: \"No search results found!\"
		};
	}

	const file = filtered.shift();
	const link = `https://github.com/${file.repository.full_name}/blob/master/${file.path}`;
	return {
		reply: `${file.name} - check here: ${link}`
	};
})',
		'async (prefix) => {
	return [
		\"If nothing is specified, posts GitHub repo links; otherwise, will execute a search on Supibot\'s repositories.\",
		\"\",

		`<code>${prefix}github</code>`,
		\"Supibot: https://github.com/Supinic/supibot - Website: https://github.com/Supinic/supinic.com\",
		\"\",

		`<code>${prefix}github (search query)</code>`,
		\"Searches supibot\'s repositories for that query\",
	];
}',
		'supinic/supibot-sql'
	)