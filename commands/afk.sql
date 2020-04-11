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
		6,
		'afk',
		'[\"gn\", \"brb\", \"shower\", \"food\", \"lurk\", \"poop\", \"💩\", \"ppPoof\", \"work\", \"study\"]',
		NULL,
		'Flags you as AFK. Supports a custom AFK message.',
		10000,
		0,
		0,
		0,
		0,
		NULL,
		0,
		0,
		0,
		0,
		1,
		0,
		0,
		'({
	foodEmojis: [
		\"🍋\",
		\"🍞\",
		\"🥐\",
		\"🥖\",
		\"🥨\",
		\"🥯\",
		\"🥞\",
		\"🧀\",
		\"🍖\",
		\"🍗\",
		\"🥩\",
		\"🥓\",
		\"🍔\",
		\"🍟\",
		\"🍕\",
		\"🌭\",
		\"🥪\",
		\"🌮\",
		\"🌯\",
		\"🥙\",
		\"🍳\",
		\"🥘\",
		\"🍲\",
		\"🥣\",
		\"🥗\",
		\"🍿\",
		\"🥫\",
		\"🍱\",
		\"🍘\",
		\"🍙\",
		\"🍚\",
		\"🍛\",
		\"🍜\",
		\"🍝\",
		\"🍠\",
		\"🍢\",
		\"🍣\",
		\"🍤\",
		\"🍥\",
		\"🍡\",
		\"🥟\",
		\"🥠\",
		\"🥡\",
		\"🍦\",
		\"🍧\",
		\"🍨\",
		\"🍩\",
		\"🍪\",
		\"🎂\",
		\"🍰\",
		\"🥧\",
		\"🍫\",
		\"🍬\",
		\"🍭\",
		\"🍮\",
		\"🍯\"
	]
})',
		'(async function afk (context, ...args) {
	if (context.privateMessage && sb.AwayFromKeyboard.data.find(i => i.User_Alias === context.user.ID)) {
		return {
			reply: \"You are already AFK!\"
		};
	}

	let text = args.join(\" \").trim();
	let status = \"now AFK\";

	switch (context.invocation) {
		case \"afk\": [status, text] = [\"now AFK\", text || \"(no message)\"]; break;
		case \"gn\": [status, text] = [\"now sleeping\", (text ? (text + \" 💤\") : \" 🛏💤\")]; break;
		case \"brb\": [status, text] = [\"going to be right back\", text || \"ppHop\"]; break;
		case \"shower\": [status, text] = [\"now taking a shower\", (text ? (text + \" 🚿\") : \" 🚿\")]; break;
		
		case \"💩\":			
		case \"poop\": 
			context.invocation = \"poop\";
			[status, text] = [\"now pooping\", (text ?  (text + \" 🚽\") : \"💩\")]; 
			break;

		case \"lurk\": [status, text] = [\"now lurking\", (text ?  (text + \" 👥\") : \" 👥\")]; break;
		case \"work\": [status, text] = [\"working\", (text ?  (text + \" 💼\") : \" 👷\")]; break;
		case \"ppPoof\": [status, text] = [\"ppPoof poofing away...\", (text || \"\") + \" 💨\"]; break;
		case \"study\": [status, text] = [\"now studying\", (text || \"🤓\") + \" 📚\"]; break;
		case \"food\": {
			let useAutoEmoji = true;
			for (const emoji of this.staticData.foodEmojis) {
				if (text.includes(emoji)) {
					useAutoEmoji = false;
				}
			}

			const appendText = (useAutoEmoji)
				? sb.Utils.randArray(this.staticData.foodEmojis)
				: \"\";

			status = \"now eating\";
			text = (text) 
				? text + \" \" + appendText 
				: \"OpieOP \" + appendText;
			break;
		}
	}
	
	await sb.AwayFromKeyboard.set(context.user, text, context.invocation, false);
	return {
		 reply: context.user.Name + \" is \" + status + \": \" + text
	}
})',
		'No arguments: Sets the status with \"(no message)\"
Any arguments given will make up the AFK message.

$afk => AFK status
$shower => Shower status
$brb => Be right back status

$afk I\'ll be back.',
		'async (prefix) => [
		\"Flags you as AFK (away from keyboard).\",
		\"While you are AFK, others can check if you are AFK.\",
		\"On your first message while AFK, the status ends and the bot will announce you coming back.\",
		\"Several aliases exist in order to make going AFK for different situations easier.\",		
		\"\",

		`<code>${prefix}afk (status)</code>`,
		`You are now AFK with the provided status`,
		``,

		`<code>${prefix}poop (status)</code>`,
		`You are now pooping.`,
		``,

		`<code>${prefix}brb (status)</code>`,
		`You will be right back.`,
		``,

		`and more - check the aliases`
]	'
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function afk (context, ...args) {
	if (context.privateMessage && sb.AwayFromKeyboard.data.find(i => i.User_Alias === context.user.ID)) {
		return {
			reply: \"You are already AFK!\"
		};
	}

	let text = args.join(\" \").trim();
	let status = \"now AFK\";

	switch (context.invocation) {
		case \"afk\": [status, text] = [\"now AFK\", text || \"(no message)\"]; break;
		case \"gn\": [status, text] = [\"now sleeping\", (text ? (text + \" 💤\") : \" 🛏💤\")]; break;
		case \"brb\": [status, text] = [\"going to be right back\", text || \"ppHop\"]; break;
		case \"shower\": [status, text] = [\"now taking a shower\", (text ? (text + \" 🚿\") : \" 🚿\")]; break;
		
		case \"💩\":			
		case \"poop\": 
			context.invocation = \"poop\";
			[status, text] = [\"now pooping\", (text ?  (text + \" 🚽\") : \"💩\")]; 
			break;

		case \"lurk\": [status, text] = [\"now lurking\", (text ?  (text + \" 👥\") : \" 👥\")]; break;
		case \"work\": [status, text] = [\"working\", (text ?  (text + \" 💼\") : \" 👷\")]; break;
		case \"ppPoof\": [status, text] = [\"ppPoof poofing away...\", (text || \"\") + \" 💨\"]; break;
		case \"study\": [status, text] = [\"now studying\", (text || \"🤓\") + \" 📚\"]; break;
		case \"food\": {
			let useAutoEmoji = true;
			for (const emoji of this.staticData.foodEmojis) {
				if (text.includes(emoji)) {
					useAutoEmoji = false;
				}
			}

			const appendText = (useAutoEmoji)
				? sb.Utils.randArray(this.staticData.foodEmojis)
				: \"\";

			status = \"now eating\";
			text = (text) 
				? text + \" \" + appendText 
				: \"OpieOP \" + appendText;
			break;
		}
	}
	
	await sb.AwayFromKeyboard.set(context.user, text, context.invocation, false);
	return {
		 reply: context.user.Name + \" is \" + status + \": \" + text
	}
})'