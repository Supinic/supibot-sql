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
		Dynamic_Description
	)
VALUES
	(
		140,
		'restart',
		NULL,
		'read-only,system,whitelist',
		'Restarts the bot by killing the process and letting PM2 restart it.',
		0,
		NULL,
		NULL,
		'(async function restart (context, ...types) {
	const { promisify } = require(\"util\");
	const shell = promisify(require(\"child_process\").exec);

	types = types.map(i => i.toLowerCase());

	const queue = [];
	if (types.includes(\"all\") || types.includes(\"pull\")) {
		queue.push(async () => {
			sb.Master.send(\"Pulling from master PogChamp 👉\", context.channel);
			await shell(\"git checkout -- yarn.lock package.json\");
			const result = await shell(\"git pull origin master\");
			console.log(\"pull result\", result);
		});
	}
	if (types.includes(\"all\") || types.includes(\"yarn\") || types.includes(\"upgrade\")) {
		queue.push(async () => {
			sb.Master.send(\"Updating supi-core module PogChamp 👉\", context.channel);
			const result = await shell(\"yarn upgrade supi-core\");
			console.log(\"upgrade result\", result);
		});
	}

	queue.push(async () => {
		sb.Master.send(\"Restarting process PogChamp 👉\", context.channel);
		setTimeout(() => process.abort(), 1000);
	});

	for (const fn of queue) {
		await fn();
	}
});',
		NULL
	)