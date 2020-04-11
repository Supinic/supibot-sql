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

	return {
		commands: [
			{
				name: \"labyrinth\",
				aliases: [\"lab\"],
				description: \"Fetches the current overview picture of today\'s labyrinth. Use a difficulty (normal, cruel, merciless, uber) to see each one separately.\"
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
			const allowed = [\"normal\", \"cruel\", \"merciless\", \"uber\"];
			if (!allowed.includes(labType)) {
				return {
					reply: \"Invalid labyrinth type provided! Supported types: \" + allowed.join(\", \")
				};
			}

			if (!this.data.labyrinth.date || this.data.labyrinth.date.day !== new sb.Date().day) {
				this.data.labyrinth.date = new sb.Date().setTimezoneOffset(0);
			}

			const dateString = this.data.labyrinth.date.format(\"Y-m-d\");
			const url = `https://www.poelab.com/wp-content/labfiles/${dateString}_${labType}.jpg`;
			if (!this.data.labyrinth[labType]) {
				const { statusCode } = await sb.Got.instances.FakeAgent({
					method: \"GET\",
					throwHttpErrors: false,
					url
				});

				this.data.labyrinth[labType] = (statusCode === 200);
				if (statusCode !== 200) {
					return {
						reply: `The ${labType} labyrinth has not been scouted yet!`
					};
				}
			}
			return {
				reply: `Today\'s ${labType} labyrinth map: ${url}`
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
			const link = userData.Data?.pathOfExile?.uniqueTabs?.dhcssf ?? null;
			if (!link) {
				return {
					success: false,
					reply: `User ${userData.Name} has no unique stash tabs set up!`
				};
			}

			return {
				reply: `${userData.Name}\'s DHCSSF unique tab: ${link}`
			};
		}

		default: return {
			reply: `Invalid query type provided! Currently supported: \"lab <difficulty>\", \"uniques <user>\".`
		}
	}
})',
		NULL,
		'async (prefix) => {
	const row = await sb.Query.getRow(\"chat_data\", \"Command\");
	await row.load(117);
	const { commands } = eval(row.values.Static_Data);	

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

ON DUPLICATE KEY UPDATE
	Code = '(async function poe (context, commandType, ...args) {
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
			const allowed = [\"normal\", \"cruel\", \"merciless\", \"uber\"];
			if (!allowed.includes(labType)) {
				return {
					reply: \"Invalid labyrinth type provided! Supported types: \" + allowed.join(\", \")
				};
			}

			if (!this.data.labyrinth.date || this.data.labyrinth.date.day !== new sb.Date().day) {
				this.data.labyrinth.date = new sb.Date().setTimezoneOffset(0);
			}

			const dateString = this.data.labyrinth.date.format(\"Y-m-d\");
			const url = `https://www.poelab.com/wp-content/labfiles/${dateString}_${labType}.jpg`;
			if (!this.data.labyrinth[labType]) {
				const { statusCode } = await sb.Got.instances.FakeAgent({
					method: \"GET\",
					throwHttpErrors: false,
					url
				});

				this.data.labyrinth[labType] = (statusCode === 200);
				if (statusCode !== 200) {
					return {
						reply: `The ${labType} labyrinth has not been scouted yet!`
					};
				}
			}
			return {
				reply: `Today\'s ${labType} labyrinth map: ${url}`
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
			const link = userData.Data?.pathOfExile?.uniqueTabs?.dhcssf ?? null;
			if (!link) {
				return {
					success: false,
					reply: `User ${userData.Name} has no unique stash tabs set up!`
				};
			}

			return {
				reply: `${userData.Name}\'s DHCSSF unique tab: ${link}`
			};
		}

		default: return {
			reply: `Invalid query type provided! Currently supported: \"lab <difficulty>\", \"uniques <user>\".`
		}
	}
})'