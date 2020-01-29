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
		104,
		'pipe',
		NULL,
		'Pipes the result of one command to another, and so forth. Each command will be used as if used separately, so each will be checked for cooldowns and banphrases. Use the pipe character \"|\" to separate each command.',
		5000,
		0,
		1,
		0,
		0,
		NULL,
		0,
		0,
		0,
		1,
		0,
		0,
		'(async function pipe (context, ...args) {
	const invocations = args.join(\" \").split(\"|\").map(i => i.trim());
	if (invocations.length < 2) {
		return { reply: \"At least two commands must be piped together!\" };
	}

	const resultsInPastebin = args[args.length - 1] === \"pastebin\";
	let finalResult = null;
	let fakeChannel = null;

	if (context.channel) {
		const tempData = {...context.channel};
		tempData.Data = JSON.stringify(tempData.Data);

		fakeChannel = new sb.Channel(tempData);
		fakeChannel.Ping = false;
	}

	let cancerCheck = false;
	let currentArgs = [];

	for (const inv of invocations) {
		let [cmd, ...cmdArgs] = inv.replace(/^\\$\\s*/, \"$\").split(\" \");
		cmdArgs = cmdArgs.concat(currentArgs);

		if (cmd.includes(\"translate\")) {
			cmdArgs.push(\"direction:false\", \"confidence:false\");
		}
		else if (cmd.includes(\"rg\")) {
			cmdArgs.push(\"linkOnly:true\");
		}

		const check = sb.Command.get(cmd.replace(sb.Config.get(\"COMMAND_PREFIX\"), \"\"));
		if (check) {
			if (!check.Pipeable) {
				return { reply: \"Command \" + cmd + \" cannot be used in a pipe!\" };
			}

			if (check.Name === \"fill\") {
				cancerCheck = true;
			}
			else if (cancerCheck && check.Name === \"texttospeech\") {
				return { reply: \"Nice try ;)\" };
			}
		}

		const result = await sb.Command.checkAndExecute(
			cmd,
			cmdArgs,
			fakeChannel,
			context.user,
			{
				...context.append,
				platform: context.platform,
				pipe: true,
				skipPending: true
			}
		);

		console.debug(\"Pipe\", result);

		if (!result) { // Banphrase result: Do not reply
			return { reply: null };
		}
		else if (typeof result !== \"object\") { // Banphrase result: Reply with message
			return { reply: result };
		}
		else if (result.reason === \"error\" && result.reply) {
			return { reply: result.reply };
		}
		else if (result.success === false) { // Command result: Failed (cooldown, no command, ...)
			let reply = \"\";
			switch (result.reason) {
				case \"no-command\": reply = \"Not a command!\"; break;
				case \"pending\": reply = \"Another command still being executed!\"; break;
				case \"cooldown\": reply = \"Still on cooldown!\"; break;
				case \"filter\": reply = \"You can\'t use this command here!\"; break;
				case \"block\": reply = \"That user has blocked you from this command!\"; break;
				case \"opt-out\": reply = \"That user has opted out from this command!\"; break;

				default: reply = `An unexpected pipe result (${result.reason}) has been encountered!`
			}

			return { 
				reply: `Command ${cmd} failed: ${reply}`
			};
		}
		else if (!result.reply) { // Command result: Failed (ban)
			return { reply: \"The final result of pipe is banphrased.\" };
		}
		else if (resultsInPastebin) {
			currentArgs = result.reply.split(\" \");
		}
		else {
			currentArgs = sb.Utils.wrapString(result.reply, 300).split(\" \");
		}

		finalResult = result;
	}

	return {
		replyWithPrivateMessage: Boolean(finalResult.replyWithPrivateMessage),
		reply: currentArgs.join(\" \")
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function pipe (context, ...args) {
	const invocations = args.join(\" \").split(\"|\").map(i => i.trim());
	if (invocations.length < 2) {
		return { reply: \"At least two commands must be piped together!\" };
	}

	const resultsInPastebin = args[args.length - 1] === \"pastebin\";
	let finalResult = null;
	let fakeChannel = null;

	if (context.channel) {
		const tempData = {...context.channel};
		tempData.Data = JSON.stringify(tempData.Data);

		fakeChannel = new sb.Channel(tempData);
		fakeChannel.Ping = false;
	}

	let cancerCheck = false;
	let currentArgs = [];

	for (const inv of invocations) {
		let [cmd, ...cmdArgs] = inv.replace(/^\\$\\s*/, \"$\").split(\" \");
		cmdArgs = cmdArgs.concat(currentArgs);

		if (cmd.includes(\"translate\")) {
			cmdArgs.push(\"direction:false\", \"confidence:false\");
		}
		else if (cmd.includes(\"rg\")) {
			cmdArgs.push(\"linkOnly:true\");
		}

		const check = sb.Command.get(cmd.replace(sb.Config.get(\"COMMAND_PREFIX\"), \"\"));
		if (check) {
			if (!check.Pipeable) {
				return { reply: \"Command \" + cmd + \" cannot be used in a pipe!\" };
			}

			if (check.Name === \"fill\") {
				cancerCheck = true;
			}
			else if (cancerCheck && check.Name === \"texttospeech\") {
				return { reply: \"Nice try ;)\" };
			}
		}

		const result = await sb.Command.checkAndExecute(
			cmd,
			cmdArgs,
			fakeChannel,
			context.user,
			{
				...context.append,
				platform: context.platform,
				pipe: true,
				skipPending: true
			}
		);

		console.debug(\"Pipe\", result);

		if (!result) { // Banphrase result: Do not reply
			return { reply: null };
		}
		else if (typeof result !== \"object\") { // Banphrase result: Reply with message
			return { reply: result };
		}
		else if (result.reason === \"error\" && result.reply) {
			return { reply: result.reply };
		}
		else if (result.success === false) { // Command result: Failed (cooldown, no command, ...)
			let reply = \"\";
			switch (result.reason) {
				case \"no-command\": reply = \"Not a command!\"; break;
				case \"pending\": reply = \"Another command still being executed!\"; break;
				case \"cooldown\": reply = \"Still on cooldown!\"; break;
				case \"filter\": reply = \"You can\'t use this command here!\"; break;
				case \"block\": reply = \"That user has blocked you from this command!\"; break;
				case \"opt-out\": reply = \"That user has opted out from this command!\"; break;

				default: reply = `An unexpected pipe result (${result.reason}) has been encountered!`
			}

			return { 
				reply: `Command ${cmd} failed: ${reply}`
			};
		}
		else if (!result.reply) { // Command result: Failed (ban)
			return { reply: \"The final result of pipe is banphrased.\" };
		}
		else if (resultsInPastebin) {
			currentArgs = result.reply.split(\" \");
		}
		else {
			currentArgs = sb.Utils.wrapString(result.reply, 300).split(\" \");
		}

		finalResult = result;
	}

	return {
		replyWithPrivateMessage: Boolean(finalResult.replyWithPrivateMessage),
		reply: currentArgs.join(\" \")
	};
})'