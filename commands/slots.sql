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
		89,
		'slots',
		NULL,
		'Once at least three unique emotes (or words) have been provided, rolls a pseudo slot machine to see if you get a flush.',
		20000,
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
		'(async function slots (context, ...emotes) {
	if (emotes[0] === \"leader\" || emotes[0] === \"leaders\") {
		return {
			reply: \"Check out all the previous slots winners here! https://supinic.com/bot/slots-winner/list\"
		};
	}

	const check = await sb.Query.getRecordset(rs => rs
		.select(\"Pattern\", \"Type\")
		.from(\"data\", \"Slots_Pattern\")
		.where(\"Name = %s\", emotes[0] || \"\")
		.single()
	);

	let limit = 3;
	let type = \"array\";
	let uniqueItems = null;
	const rolledItems = [];
	if (check) {
		if (check.Type === \"Array\") {
			emotes = JSON.parse(check.Pattern);
		}
		else if (check.Type === \"Function\") {
			const fn = eval(check.Pattern);
			const result = await fn(context, ...emotes);

			// This basically means something went wrong somehow (like no emotes found in that channel)
			// Reply with that response instead of rolling for emotes.
			if (typeof result === \"string\") {
				return { reply: result };
			}
			else if (Array.isArray(result)) {
				emotes = result;
			}
			else if (result.constructor === Object) {
				if (typeof result.roll === \"function\") {
					limit = result.limit || limit;
					uniqueItems = result.uniqueItems;
					type = \"function\";

					for (let i = 0; i < limit; i++) {
						rolledItems.push(result.roll());
					}

				}
				else if (Array.isArray(result.emotes)) {
					emotes = result.emotes;
					limit = result.limit || limit;
				}
			}
		}
	}

	if (type === \"array\") {
		if (emotes.length < limit) {
			return { reply: \"You must provide at least \" + limit + \" emotes/words to roll the slots!\" };
		}

		for (let i = 0; i < limit; i++) {
			rolledItems.push(sb.Utils.randArray(emotes));
		}

		uniqueItems = emotes.filter((i, ind, arr) => arr.indexOf(i) === ind).length;
	}

	if (rolledItems.every(i => rolledItems[0] === i)) {
		if (uniqueItems === 1) {
			return {
				reply: `[ ${rolledItems.join(\" \")} ] -- FeelsDankMan You won and beat the odds of 100%.`
			};
		}

		let chance = null;
		if (type === \"array\") {
			const winningItems = emotes.filter(i => i === rolledItems[0]);
			chance = (winningItems.length === 1)
				? (winningItems.length / emotes.length) ** (limit - 1)
				: (winningItems.length / emotes.length) ** (limit);
		}
		else if (type === \"function\") {
			chance = (1 / uniqueItems) ** (limit - 1);
		}

		const reverseChance = sb.Utils.round((1 / chance), 3);
		const row = await sb.Query.getRow(\"data\", \"Slots_Winner\");
		row.setValues({
			User_Alias: context.user.ID,
			Source: (Array.isArray(emotes))
				? emotes.join(\" \")
				: (\"Number roll: 1 to \" + uniqueItems),
			Result: rolledItems.join(\" \"),
			Channel: context.channel?.ID ?? null,
			Odds: reverseChance
		});

		await row.save();
		return {
			reply: `[ ${rolledItems.join(\" \")} ] -- PagChomp A flush! Congratulations, you beat the odds of ${sb.Utils.round(chance * 100, 3)}% (that is 1 in ${reverseChance})`
		};
	}

	return {
		reply: `[ ${rolledItems.join(\" \")} ]`
	};
})',
		NULL,
		'async (prefix) => {
	const patterns = (await sb.Query.getRecordset(rs => rs
		.select(\"Name\", \"Notes\")
		.from(\"data\", \"Slots_Pattern\")
	)).map(i => i.Name + \": \" + i.Notes);

	return [
		\"Rolls three random words out of the given list of words. If you get a flush, you win!\",
		\"You can also specify special patterns, starting with the prefix #:\",
		...patterns,
		\"\",
		prefix + \"slots (list of words) => randomly shuffled list of emotes\",
		prefix + \"slots #(pattern) => shuffled list from the pattern\"
	];
}'
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function slots (context, ...emotes) {
	if (emotes[0] === \"leader\" || emotes[0] === \"leaders\") {
		return {
			reply: \"Check out all the previous slots winners here! https://supinic.com/bot/slots-winner/list\"
		};
	}

	const check = await sb.Query.getRecordset(rs => rs
		.select(\"Pattern\", \"Type\")
		.from(\"data\", \"Slots_Pattern\")
		.where(\"Name = %s\", emotes[0] || \"\")
		.single()
	);

	let limit = 3;
	let type = \"array\";
	let uniqueItems = null;
	const rolledItems = [];
	if (check) {
		if (check.Type === \"Array\") {
			emotes = JSON.parse(check.Pattern);
		}
		else if (check.Type === \"Function\") {
			const fn = eval(check.Pattern);
			const result = await fn(context, ...emotes);

			// This basically means something went wrong somehow (like no emotes found in that channel)
			// Reply with that response instead of rolling for emotes.
			if (typeof result === \"string\") {
				return { reply: result };
			}
			else if (Array.isArray(result)) {
				emotes = result;
			}
			else if (result.constructor === Object) {
				if (typeof result.roll === \"function\") {
					limit = result.limit || limit;
					uniqueItems = result.uniqueItems;
					type = \"function\";

					for (let i = 0; i < limit; i++) {
						rolledItems.push(result.roll());
					}

				}
				else if (Array.isArray(result.emotes)) {
					emotes = result.emotes;
					limit = result.limit || limit;
				}
			}
		}
	}

	if (type === \"array\") {
		if (emotes.length < limit) {
			return { reply: \"You must provide at least \" + limit + \" emotes/words to roll the slots!\" };
		}

		for (let i = 0; i < limit; i++) {
			rolledItems.push(sb.Utils.randArray(emotes));
		}

		uniqueItems = emotes.filter((i, ind, arr) => arr.indexOf(i) === ind).length;
	}

	if (rolledItems.every(i => rolledItems[0] === i)) {
		if (uniqueItems === 1) {
			return {
				reply: `[ ${rolledItems.join(\" \")} ] -- FeelsDankMan You won and beat the odds of 100%.`
			};
		}

		let chance = null;
		if (type === \"array\") {
			const winningItems = emotes.filter(i => i === rolledItems[0]);
			chance = (winningItems.length === 1)
				? (winningItems.length / emotes.length) ** (limit - 1)
				: (winningItems.length / emotes.length) ** (limit);
		}
		else if (type === \"function\") {
			chance = (1 / uniqueItems) ** (limit - 1);
		}

		const reverseChance = sb.Utils.round((1 / chance), 3);
		const row = await sb.Query.getRow(\"data\", \"Slots_Winner\");
		row.setValues({
			User_Alias: context.user.ID,
			Source: (Array.isArray(emotes))
				? emotes.join(\" \")
				: (\"Number roll: 1 to \" + uniqueItems),
			Result: rolledItems.join(\" \"),
			Channel: context.channel?.ID ?? null,
			Odds: reverseChance
		});

		await row.save();
		return {
			reply: `[ ${rolledItems.join(\" \")} ] -- PagChomp A flush! Congratulations, you beat the odds of ${sb.Utils.round(chance * 100, 3)}% (that is 1 in ${reverseChance})`
		};
	}

	return {
		reply: `[ ${rolledItems.join(\" \")} ]`
	};
})'