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
		NULL,
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

			const date = new sb.Date().addHours(-2).format(\"Y-m-d\");
			const url = `https://www.poelab.com/wp-content/labfiles/${date}_${labType}.jpg`;
			return {
				reply: \"Latest labyrinth map: \" + url
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

			const date = new sb.Date().addHours(-2).format(\"Y-m-d\");
			const url = `https://www.poelab.com/wp-content/labfiles/${date}_${labType}.jpg`;
			return {
				reply: \"Latest labyrinth map: \" + url
			};
		}
		
		default: return {
			reply: `Invalid query type provided! Currently supported: \"lab\".`
		}
	}
})'