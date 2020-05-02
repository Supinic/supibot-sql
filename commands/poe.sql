INSERT INTO
	`chat_data`.`Command`
	(
		ID,
		Name,
		Aliases,
		Flags,
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
		Owner_Override,
		Archived,
		Static_Data,
		Code,
		Examples,
		Dynamic_Description
	)
VALUES
	(
		117,
		'poe',
		NULL,
		NULL,
		'Checks the current price of any recently traded item. $poe <league> <item>',
		7500,
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
		0,
		'(() => {
	if (this?.data) {
		this.data.labyrinth = {
			date: null,
			normal: null,
			cruel: null,
			merciless: null,
			uber: null
		};
	}

	const trials = {
		normal: \"A1: Lower Prison; A2: Crypt lvl 1, Chamber of Sins lvl 2; A3: Crematorium, Catacombs, Imperial Gardens\",
		cruel: \"A6: Prison; A7: Crypt; A7: Chamber of Sins lvl 2\",
		merciless: \"A8: Bath House; A9: Tunnel; A10: Ossuary\"
	};

	trials.all = Object.values(trials).join(\" -- \");

	return {
		trials,
		commands: [
			{
				name: \"labyrinth\",
				aliases: [\"lab\"],
				description: \"Fetches the current overview picture of today\'s Labyrinth. Use a difficulty (normal, cruel, merciless, uber) to see each one separately.\"
			},
			{
				name: \"syndicate\",
				aliases: [],
				description: \"Fetches info about the Syndicate. If nothing is specified, you get a chart. You can also specify a Syndicate member to get their overview, or add a position to be even more specific.\"
			},
			{
				name: \"trial\",
				aliases: [\"trials\"],
				description: \"Fetches info about the Labyrinth trials for specified difficulty, or overall if not specified.\"
			},
			{
				name: \"uniques\",
				aliases: [],
				description: \"If a user has requested to have their unique stash tab available on supibot, you can get its link by invoking this sub-command.\"
			}
		]
	};
})();',
		'(async function poe (context, commandType, ...args) {
	if (!commandType) {
		return {
			reply: `No query type provided! Currently supported: \"lab\".`
		};
	}

	commandType = commandType.toLowerCase();

	switch (commandType) {
		case \"lab\":
		case \"labyrinth\": {
			const labType = (args[0] || \"\").toLowerCase();
			const types = [\"uber\", \"merciless\", \"cruel\", \"normal\"];
			if (!types.includes(labType)) {
				return {
					reply: \"Invalid labyrinth type provided! Supported types: \" + types.join(\", \")
				};
			}

			if (!this.data.labyrinth.date || this.data.labyrinth.date.day !== new sb.Date().day) {
				this.data.labyrinth.date = new sb.Date().setTimezoneOffset(0);
				this.data.details = {};

				const html = await sb.Got.instances.FakeAgent(\"https://poelab.com\").text();
				const $ = sb.Utils.cheerio(html);
				const links = Array.from($(\".redLink\").slice(0, 4).map((_, i) => i.attribs.href));

				for (let i = 0; i < links.length; i++) {
					const type = types[i];
					this.data.details[type] = {
						type,
						link: links[i],
						imageLink: null
					};
				}
			}

			const detail = this.data.details[labType];
			if (detail.imageLink === null) {
				const html = await sb.Got.instances.FakeAgent(detail.link).text();
				const $ = sb.Utils.cheerio(html);

				detail.imageLink = $(\"#notesImg\")[0].attribs.src;
			}

			return {
				reply: `Today\'s ${labType} labyrinth map: ${detail.imageLink}`
			};
		}

		case \"syndicate\": {
			const person = args.shift();
			if (!person) {
				return {
					reply: \"Check the Syndicate sheet here: https://poesyn.xyz/syndicate or the picture here: https://i.nuuls.com/huXFC.png\"
				};
			}

			const type = (args.shift()) ?? null;
			const data = await sb.Query.getRecordset(rs => rs
				.select(\"*\")
				.from(\"poe\", \"Syndicate\")
				.where(\"Name = %s\", person)
				.limit(1)
				.single()
			);

			if (!data) {
				return {
					success: false,
					reply: \"Syndicate member or type does not exist!\"
				};
			}

			return {
				reply: (type === null)
					? Object.entries(data).map(([key, value]) => `${key}: ${value}`).join(\"; \")
					: `${data.Name} at ${type}: ${data[sb.Utils.capitalize(type)]}`
			};
		}

		case \"trial\":
		case \"trials\": {
			const trialType = args.shift() ?? \"all\";
			return { 
				reply: this.staticData.trials[trialType] ?? \"Invalid trial type provided!\"
			};
		}

		case \"uniques\": {
			let [user, type] = args;
			if (!user) {
				if (!context.channel) {
					return {
						success: false,
						reply: \"Must provide a user name - no channel is available!\"
					}
				}

				user = context.channel.Name;
			}

			const userData = await sb.User.get(user);
			const link = userData.Data?.pathOfExile?.uniqueTabs ?? null;
			if (!link) {
				return {
					success: false,
					reply: `User ${userData.Name} has no unique stash tabs set up!`
				};
			}

			return {
				reply: `${userData.Name}\'s unique tab(s): ${link}`
			};
		}

		default: return {
			reply: `Invalid query type provided! Currently supported: \"lab <difficulty>\", \"uniques <user>\".`
		}
	}
})',
		NULL,
		'async (prefix, commandValues) => {
	const { commands } = eval(commandValues.Static_Data);	
	return [
		\"Multiple commands related to Path of Exile.\",
		\"\",

		...commands.flatMap(command => [
			`<code>${prefix}poe ${command.name}</code>`,
			command.description,
			\"\"
		])
	];
}'
	)