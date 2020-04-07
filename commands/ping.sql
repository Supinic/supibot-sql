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
		'({
	checkLatency: async (callback, ...args) => {
		const start = process.hrtime.bigint();
		await callback(...args);
		
		return sb.Utils.round(Number(process.hrtime.bigint() - start) / 1.0e6, 3);
	}
})',
		'(async function ping (context) {
	const promisify = require(\"util\").promisify;
	const readFile = require(\"fs\").promises.readFile;
	const exec = promisify(require(\"child_process\").exec);
	const chars = {a: \"e\", e: \"i\", i: \"o\", o: \"u\", u: \"y\", y: \"a\"};

	const startLatency = process.hrtime();
	await sb.Master.clients.twitch.client.ping();
	const endLatency = process.hrtime(startLatency);

	const [temperature, memory] = await Promise.all([
		exec(\"/opt/vc/bin/vcgencmd measure_temp\"),
		readFile(\"/proc/meminfo\")
	]);

	const memoryData = String(memory).split(\"\\n\").filter(Boolean).map(i => Number(i.split(/:\\s+/)[1].replace(/kB/, \"\")) * 1000);
	const pong = \"P\" + chars[context.invocation[1]] + \"ng!\";

	const data = {
		Uptime: sb.Utils.timeDelta(sb.Master.started).replace(\"ago\", \"\").trim(),
		Temperature: temperature.stdout.match(/([\\d\\.]+)/)[1] + \"°C\",
		\"Free memory\": sb.Utils.formatByteSize(memoryData[2], 0) + \"/\" + sb.Utils.formatByteSize(memoryData[0], 0),
		\"Commands used\": sb.Runtime.commandsUsed
	};

	if (context.channel) {
		const type = context.channel.Banphrase_API_Type;
		const url = context.channel.Banphrase_API_URL;

		if (type && url) {
			const ping = await this.staticData.checkLatency(
				async () => sb.Banphrase.executeExternalAPI(\"test\", type, url)
			);

			data[\"Banphrase API\"] = `Using ${type} API: ${url} (${Math.trunc(ping)}ms)`;
		}
		else {
			data[\"Banphrase API\"] = \"Not connected.\"
		}		
	}	

	if (context.platform.Name === \"twitch\") {
		data[\"Latency to TMI\"] = await this.staticData.checkLatency(
			async () => sb.Master.clients.twitch.client.ping()
		);
	}

	return {
		reply: pong + \" \" + Object.entries(data).map(([name, value]) => name + \": \" + value).join(\"; \")
	};
})',
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
	Code = '(async function ping (context) {
	const promisify = require(\"util\").promisify;
	const readFile = require(\"fs\").promises.readFile;
	const exec = promisify(require(\"child_process\").exec);
	const chars = {a: \"e\", e: \"i\", i: \"o\", o: \"u\", u: \"y\", y: \"a\"};

	const startLatency = process.hrtime();
	await sb.Master.clients.twitch.client.ping();
	const endLatency = process.hrtime(startLatency);

	const [temperature, memory] = await Promise.all([
		exec(\"/opt/vc/bin/vcgencmd measure_temp\"),
		readFile(\"/proc/meminfo\")
	]);

	const memoryData = String(memory).split(\"\\n\").filter(Boolean).map(i => Number(i.split(/:\\s+/)[1].replace(/kB/, \"\")) * 1000);
	const pong = \"P\" + chars[context.invocation[1]] + \"ng!\";

	const data = {
		Uptime: sb.Utils.timeDelta(sb.Master.started).replace(\"ago\", \"\").trim(),
		Temperature: temperature.stdout.match(/([\\d\\.]+)/)[1] + \"°C\",
		\"Free memory\": sb.Utils.formatByteSize(memoryData[2], 0) + \"/\" + sb.Utils.formatByteSize(memoryData[0], 0),
		\"Commands used\": sb.Runtime.commandsUsed
	};

	if (context.channel) {
		const type = context.channel.Banphrase_API_Type;
		const url = context.channel.Banphrase_API_URL;

		if (type && url) {
			const ping = await this.staticData.checkLatency(
				async () => sb.Banphrase.executeExternalAPI(\"test\", type, url)
			);

			data[\"Banphrase API\"] = `Using ${type} API: ${url} (${Math.trunc(ping)}ms)`;
		}
		else {
			data[\"Banphrase API\"] = \"Not connected.\"
		}		
	}	

	if (context.platform.Name === \"twitch\") {
		data[\"Latency to TMI\"] = await this.staticData.checkLatency(
			async () => sb.Master.clients.twitch.client.ping()
		);
	}

	return {
		reply: pong + \" \" + Object.entries(data).map(([name, value]) => name + \": \" + value).join(\"; \")
	};
})'