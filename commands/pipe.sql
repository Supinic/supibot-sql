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
		Dynamic_Description,
		Source
	)
VALUES
	(
		104,
		'pipe',
		NULL,
		'ping,pipe,system',
		'Pipes the result of one command to another, and so forth. Each command will be used as if used separately, so each will be checked for cooldowns and banphrases. Use the character \"|\" or \">\" to separate each command.',
		5000,
		NULL,
		NULL,
		'(async function pipe (context, ...args) {
	const invocations = args.join(\" \").split(/[|>]/).map(i => i.trim());
	if (!context.externalPipe && invocations.length < 2) {
		return { reply: \"At least two commands must be piped together!\" };
	}

	const resultsInPastebin = args[args.length - 1] === \"pastebin\";
	let finalResult = null;
	let currentArgs = [];

	for (const inv of invocations) {
		let [cmd, ...cmdArgs] = inv.split(\" \");
		cmdArgs = cmdArgs.concat(currentArgs);

		if (cmd.includes(\"translate\")) {
			cmdArgs.push(\"direction:false\", \"confidence:false\");
		}
		else if (cmd.includes(\"rg\")) {
			cmdArgs.push(\"linkOnly:true\");
		}

		const check = sb.Command.get(cmd.replace(sb.Command.prefix, \"\"));
		if (check) {
			if (!check.Flags.pipe) {
				return { reply: \"Command \" + cmd + \" cannot be used in a pipe!\" };
			}
		}

		const result = await sb.Command.checkAndExecute(
			cmd,
			cmdArgs,
			context.channel,
			context.user,
			{
				...context.append,
				platform: context.platform,
				pipe: true,
				skipBanphrases: true,
				skipPending: true,
				skipPing: true
			}
		);

		console.debug(\"Pipe\", result);

		if (!result) { // Banphrase result: Do not reply
			currentArgs = [];
		}
		else if (typeof result !== \"object\") { // Banphrase result: Reply with message
			return { reply: result };
		}
		else if (result.reason === \"bad_invocation\" && result.reply) {
			return { reply: `Command \"${cmd}\" failed: ${result.reply}` };
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
				case \"pipe-nsfw\": reply = \"You cannot pipe NSFW results!\"; break;

				default: reply = result.reason ?? result.reply;
			}

			return {
				reply: `Pipe will not continue, because command ${cmd} failed: ${reply}`
			};
		}
		else if (!result.reply) { // Command result: Failed (ban)
			return { reply: \"The final result of pipe is banphrased.\" };
		}
		else if (resultsInPastebin) {
			currentArgs = result.reply.split(\" \");
		}
		else {
			currentArgs = sb.Utils.wrapString(result.reply, 2000).split(\" \");
		}

		finalResult = result;
	}

	return {
		replyWithPrivateMessage: Boolean(finalResult?.replyWithPrivateMessage),
		reply: currentArgs.join(\" \")
	};
})',
		'async (prefix) => {
	return [
		\"Pipes multiple commands together, where each command\'s result will become the input of another.\",
		\"Separate the commands with <code>|</code> or <code>&gt;</code> characters.\",
		\"\",
		
		`<code>${prefix}pipe news RU | translate</code>`,
		\"Fetches russian news, and immediately translates them to English (by default).\",
		\"\",

		`<code>${prefix}pipe 4Head | translate to:german | notify (user)</code>`,
		\"Fetches a random joke, translates it to German, and reminds the target user with the text.\",
		\"\"		
	];
}',
		'supinic/supibot-sql'
	)