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
		return {
			reply: \"Text-to-speech is currently disabled!\"
		};
	}
	else if (args.length === 0) {
		return {
			reply: \"No message provided!\",
			cooldown: {
				length: 1000
			}
		};
	}

	const limit = sb.Config.get(\"TTS_TIME_LIMIT\");
	const availableVoices = Object.values(sb.Config.get(\"TTS_VOICE_DATA\")).map(i => i.name.toLowerCase());
	let voice = \"Brian\";
	for (let i = args.length - 1; i >= 0; i--) {
		const token = args[i];
		if (/voice:\\w+/.test(token)) {
			voice = sb.Utils.capitalize(token.split(\":\")[1]);
			args.splice(i, 1);
		}
	}

	if (!availableVoices.includes(voice.toLowerCase())) {
		return {
			reply: \"Provided voice does not exist!\",
			cooldown: {
				length: 2500
			}
		};
	}
	else if (!sb.Config.get(\"TTS_MULTIPLE_ENABLED\")) {
		if (this.data.pending) {
			return {
				reply: \"Someone else is using the TTS right now, and multiple TTS is not available right now!\",
				cooldown: {
					length: 2500
				}
			};
		}

		this.data.pending = true;
	}

	let messageTime = 0n;
	let result = null;
	const message = args.join(\" \").trim();
	
	try {
		messageTime = process.hrtime.bigint();
		result = await sb.LocalRequest.playTextToSpeech({
			text: message,
			volume: sb.Config.get(\"TTS_VOLUME\"),
			limit,
			voice
		});

		messageTime = process.hrtime.bigint() - messageTime;
	}
	catch (e) {
		console.log(e);
		await sb.Config.set(\"TTS_ENABLED\", false);
		return {
			reply: \"The desktop listener is not currently running, turning off text to speech!\"
		};
	}
	finally {
		this.data.pending = false;
	}

	if (result === null || result === false) {
		return {
			reply: `Your TTS was refused, because its length exceeded the limit of ${limit / 1000} seconds!`,
			cooldown: { length: 5000 }
		};
	}

	const duration = sb.Utils.round(Number(messageTime) / 1.0e6, 0);
	const cooldown = (duration > 10000)
		? (context.command.Cooldown + (duration - 10000) * 10)
		: context.command.Cooldown;

	return {
		reply: `Your message has been succesfully played on TTS! It took ${duration / 1000} seconds to read out, and your cooldown is ${cooldown / 1000} seconds.`,
		cooldown: {
			length: cooldown
		}
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function textToSpeech (context, ...args) {
	if (!sb.Config.get(\"TTS_ENABLED\")) {
		return {
			reply: \"Text-to-speech is currently disabled!\"
		};
	}
	else if (args.length === 0) {
		return {
			reply: \"No message provided!\",
			cooldown: {
				length: 1000
			}
		};
	}

	const limit = sb.Config.get(\"TTS_TIME_LIMIT\");
	const availableVoices = Object.values(sb.Config.get(\"TTS_VOICE_DATA\")).map(i => i.name.toLowerCase());
	let voice = \"Brian\";
	for (let i = args.length - 1; i >= 0; i--) {
		const token = args[i];
		if (/voice:\\w+/.test(token)) {
			voice = sb.Utils.capitalize(token.split(\":\")[1]);
			args.splice(i, 1);
		}
	}

	if (!availableVoices.includes(voice.toLowerCase())) {
		return {
			reply: \"Provided voice does not exist!\",
			cooldown: {
				length: 2500
			}
		};
	}
	else if (!sb.Config.get(\"TTS_MULTIPLE_ENABLED\")) {
		if (this.data.pending) {
			return {
				reply: \"Someone else is using the TTS right now, and multiple TTS is not available right now!\",
				cooldown: {
					length: 2500
				}
			};
		}

		this.data.pending = true;
	}

	let messageTime = 0n;
	let result = null;
	const message = args.join(\" \").trim();
	
	try {
		messageTime = process.hrtime.bigint();
		result = await sb.LocalRequest.playTextToSpeech({
			text: message,
			volume: sb.Config.get(\"TTS_VOLUME\"),
			limit,
			voice
		});

		messageTime = process.hrtime.bigint() - messageTime;
	}
	catch (e) {
		console.log(e);
		await sb.Config.set(\"TTS_ENABLED\", false);
		return {
			reply: \"The desktop listener is not currently running, turning off text to speech!\"
		};
	}
	finally {
		this.data.pending = false;
	}

	if (result === null || result === false) {
		return {
			reply: `Your TTS was refused, because its length exceeded the limit of ${limit / 1000} seconds!`,
			cooldown: { length: 5000 }
		};
	}

	const duration = sb.Utils.round(Number(messageTime) / 1.0e6, 0);
	const cooldown = (duration > 10000)
		? (context.command.Cooldown + (duration - 10000) * 10)
		: context.command.Cooldown;

	return {
		reply: `Your message has been succesfully played on TTS! It took ${duration / 1000} seconds to read out, and your cooldown is ${cooldown / 1000} seconds.`,
		cooldown: {
			length: cooldown
		}
	};
})'