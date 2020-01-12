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
		86,
		'texttospeech',
		'[\"tts\"]',
		'Plays TTS on stream, if enabled. You can specify voice by using \"voice:<name>\" anywhere in your message. Available voices: https://supinic.com/stream/tts',
		10000,
		0,
		0,
		1,
		1,
		NULL,
		0,
		0,
		0,
		1,
		1,
		0,
		'(async function textToSpeech (context, ...args) {
	if (!sb.Config.get(\"TTS_ENABLED\")) {
		return { reply: \"Text-to-speech is currently disabled!\" };
	}

	let voice = \"Brian\";
	for (let i = args.length - 1; i >= 0; i--) {
		const token = args[i];
		if (/voice:\\w+/.test(token)) {
			voice = sb.Utils.capitalize(token.split(\":\")[1]);
			args.splice(i, 1);
		}
	}

	let success = false;
	let messageTime = 0n;
	const message = sb.Utils.wrapString(args.join(\" \"), 250);	

	try {
		messageTime = process.hrtime.bigint(),
		success = await sb.LocalRequest.playTextToSpeech({
			text: message,
			volume: sb.Config.get(\"TTS_VOLUME\"),
			voice
		});
		
		messageTime = process.hrtime.bigint() - messageTime;
	}
	catch (e) {
		await sb.Config.set(\"TTS_ENABLED\", false);
		return { reply: \"TTS is not currently running, setting config to false :(\" }
	}

	if (!success) {
		return { 
			reply: \"Someone else is currently using the TTS!\",
			cooldown: null
		};
	}
	else {
		const duration = sb.Utils.round(Number(messageTime) / 1e6, 0);
		return {
			reply: `Your message has been succesfully played on TTS! It took ${duration / 1e3} seconds to read out.`,
			cooldown: {
				length: (duration > 10000) 
					? (context.command.Cooldown + (duration - 10000) * 5)
					: context.command.Cooldown
			}
		};
	}
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function textToSpeech (context, ...args) {
	if (!sb.Config.get(\"TTS_ENABLED\")) {
		return { reply: \"Text-to-speech is currently disabled!\" };
	}

	let voice = \"Brian\";
	for (let i = args.length - 1; i >= 0; i--) {
		const token = args[i];
		if (/voice:\\w+/.test(token)) {
			voice = sb.Utils.capitalize(token.split(\":\")[1]);
			args.splice(i, 1);
		}
	}

	let success = false;
	let messageTime = 0n;
	const message = sb.Utils.wrapString(args.join(\" \"), 250);	

	try {
		messageTime = process.hrtime.bigint(),
		success = await sb.LocalRequest.playTextToSpeech({
			text: message,
			volume: sb.Config.get(\"TTS_VOLUME\"),
			voice
		});
		
		messageTime = process.hrtime.bigint() - messageTime;
	}
	catch (e) {
		await sb.Config.set(\"TTS_ENABLED\", false);
		return { reply: \"TTS is not currently running, setting config to false :(\" }
	}

	if (!success) {
		return { 
			reply: \"Someone else is currently using the TTS!\",
			cooldown: null
		};
	}
	else {
		const duration = sb.Utils.round(Number(messageTime) / 1e6, 0);
		return {
			reply: `Your message has been succesfully played on TTS! It took ${duration / 1e3} seconds to read out.`,
			cooldown: {
				length: (duration > 10000) 
					? (context.command.Cooldown + (duration - 10000) * 5)
					: context.command.Cooldown
			}
		};
	}
})'