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
		117,
		'poe',
		NULL,
		'Checks the current price of any recently traded item. $poe <league> <item>',
		7500,
		0,
		1,
		0,
		0,
		NULL,
		0,
		0,
		0,
		1,
		1,
		0,
		'(() => {
	this.data.labyrinth = {
		date: null,
		normal: null,
		cruel: null,
		merciless: null,
		uber: null
	};

	return {};
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
			return {
				reply: \"https://www.pathofexile.com/account/view-stash/Supinic/67dd5d58434a0f9bedde7b6604113198638f7b9338629b7dc514c39893b14fb6\"
			};
		}
		
		default: return {
			reply: `Invalid query type provided! Currently supported: \"lab\".`
		}
	}
})',
		NULL,
		NULL
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
			return {
				reply: \"https://www.pathofexile.com/account/view-stash/Supinic/67dd5d58434a0f9bedde7b6604113198638f7b9338629b7dc514c39893b14fb6\"
			};
		}
		
		default: return {
			reply: `Invalid query type provided! Currently supported: \"lab\".`
		}
	}
})'