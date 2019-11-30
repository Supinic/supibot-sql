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
		1,
		'ping',
		'[\"pang\",\"peng\",\"pong\",\"pung\",\"pyng\"]',
		'Ping!',
		5000,
		0,
		0,
		1,
		0,
		NULL,
		0,
		0,
		0,
		0,
		1,
		0,
		'async (extra) => {
	const exec = require(\"child_process\").execSync;
	const chars = {a: \"e\", e: \"i\", i: \"o\", o: \"u\", u: \"y\", y: \"a\"};
	
	const startLatency = process.hrtime();
	await sb.Master.clients.twitch.client.ping();
	const endLatency = process.hrtime(startLatency);
	const pong = \"P\" + chars[extra.invocation[1]] + \"ng!\";

	const data = {
		Uptime: sb.Utils.timeDelta(sb.Master.started).replace(\"ago\", \"\").trim(),
		Temperature: exec(\"/opt/vc/bin/vcgencmd measure_temp\").toString().match(/([\\d\\.]+)/)[1] + \"°C\",
		\"Latency to TMI\": (endLatency[0] * 1e3 + endLatency[1] / 1e6) + \" ms\",
		\"Commands used\": sb.Runtime.commandsUsed		
	};

	return {
		reply: pong + \" \" + Object.entries(data).map(([name, value]) => name + \": \" + value).join(\"; \")
	};
}',
		NULL,
		'async (prefix) => {
	return [
		\"Pings the bot, checking if it\'s alive, and a bunch of other data, like latency and commands used this session\",
		\"No arguments.\",
		\"\",
		prefix + \"ping => Pong! Latency: ..., Commands used: ...\",
		prefix + \"pong => Peng! Latency: ..., Commands used: ...\",
		prefix + \"pung => Pyng! Latency: ..., Commands used: ...\",
		\"...\"
	];
}'
	)

ON DUPLICATE KEY UPDATE
	Code = 'async (extra) => {
	const exec = require(\"child_process\").execSync;
	const chars = {a: \"e\", e: \"i\", i: \"o\", o: \"u\", u: \"y\", y: \"a\"};
	
	const startLatency = process.hrtime();
	await sb.Master.clients.twitch.client.ping();
	const endLatency = process.hrtime(startLatency);
	const pong = \"P\" + chars[extra.invocation[1]] + \"ng!\";

	const data = {
		Uptime: sb.Utils.timeDelta(sb.Master.started).replace(\"ago\", \"\").trim(),
		Temperature: exec(\"/opt/vc/bin/vcgencmd measure_temp\").toString().match(/([\\d\\.]+)/)[1] + \"°C\",
		\"Latency to TMI\": (endLatency[0] * 1e3 + endLatency[1] / 1e6) + \" ms\",
		\"Commands used\": sb.Runtime.commandsUsed		
	};

	return {
		reply: pong + \" \" + Object.entries(data).map(([name, value]) => name + \": \" + value).join(\"; \")
	};
}'