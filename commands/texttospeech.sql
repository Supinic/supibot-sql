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
		86,
		'texttospeech',
		'[\"tts\"]',
		'Plays TTS on stream, if enabled. You can specify voice by using \"voice:<name>\" or \"lang:<language>\" anywhere in your message. Available voices: https://supinic.com/stream/tts',
		10000,
		0,
		0,
		1,
		0,
		NULL,
		0,
		0,
		0,
		1,
		1,
		0,
		NULL,
		'(async function textToSpeech (context, ...args) {
	if (context.channel?.ID !== 38 || args.length === 0) {
		return {
			reply: \"List of available voices: https://supinic.com/stream/tts\"
		};
	}
	else if (!sb.Config.get(\"TTS_ENABLED\")) {
		return {
			reply: \"Text-to-speech is currently disabled!\"
		};
	}
	else if (!sb.Config.get(\"TTS_MULTIPLE_ENABLED\")) {
		if (this.data.pending) {
			return {
				reply: \"Someone else is using the TTS right now, and multiple TTS is not available right now!\",
				cooldown: { length: 2500 }
			};
		}

		this.data.pending = true;
	}

	const partCheck = (string) => string.match(/^(voice|lang):\\w+$/);
	const limit = sb.Config.get(\"TTS_TIME_LIMIT\");
	const voiceData = sb.Config.get(\"TTS_VOICE_DATA\");
	const availableVoices = voiceData.map(i => i.name.toLowerCase());
	const voiceMap = Object.fromEntries(voiceData.map(i => [i.name, i.id]));
	const ttsData = [];
	let currentVoice = \"Brian\";
	let currentText = [];

	for (const token of args) {
		if (partCheck(token)) {
			let newVoice = null;
			let [type, param] = token.split(\":\");
			if (!type || !param) {
				this.data.pending = false;
				return {
					reply: `Incorrect format provided! Use (voice|lang):(name) instead.`
				};
			}

			param = param.toLowerCase();

			if (type === \"lang\") {
				const filtered = voiceData.filter(i => i.lang.toLowerCase().includes(param));
				if (filtered.length === 0) {
					this.data.pending = false;
					return {
						reply: `Language not found: ${param}`
					};
				}

				newVoice = sb.Utils.randArray(filtered).name;
			}
			else if (type === \"voice\") {
				if (param === \"random\") {
					param = sb.Utils.randArray(availableVoices);
				}

				if (!availableVoices.includes(param)) {
					this.data.pending = false;
					return {
						reply: `Voice not found: ${param}`,
						cooldown: { length: 2500 }
					};
				}

				newVoice = sb.Utils.capitalize(param);
			}

			if (newVoice !== currentVoice)  {
				if (currentText.length > 0) {
					ttsData.push({
						voice: currentVoice,
						text: currentText.join(\" \")
					});
				}

				currentVoice = newVoice;
				currentText = [];
			}
		}
		else {
			currentText.push(token);
		}
	}

	ttsData.push({
		voice: currentVoice,
		text: currentText.join(\" \")
	});

	if (ttsData.length > 3) {
		this.data.pending = false;
		return {
			reply: `Your TTS was refused! You used too many voices - ${ttsData.length}, but the maximum is 3.`,
			cooldown: { length: 5000 }
		};
	}

	for (const record of ttsData) {
		record.voice = voiceMap[record.voice];
	}

	let messageTime = 0n;
	let result = null;
	try {
		messageTime = process.hrtime.bigint();
		result = await sb.LocalRequest.playTextToSpeech({
			tts: ttsData,
			volume: sb.Config.get(\"TTS_VOLUME\"),
			limit: sb.Config.get(\"TTS_TIME_LIMIT\")
		});
		messageTime = process.hrtime.bigint() - messageTime;
	}
	catch (e) {
		console.log(e);
		await sb.Config.set(\"TTS_ENABLED\", false);
		return {
			reply: \"TTS Listener encountered an error or is turned on. Turning off text to speech!\"
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
	let cooldown = (duration > 10000)
		? (context.command.Cooldown + (duration - 10000) * 10) * (ttsData.length)
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
	if (context.channel?.ID !== 38 || args.length === 0) {
		return {
			reply: \"List of available voices: https://supinic.com/stream/tts\"
		};
	}
	else if (!sb.Config.get(\"TTS_ENABLED\")) {
		return {
			reply: \"Text-to-speech is currently disabled!\"
		};
	}
	else if (!sb.Config.get(\"TTS_MULTIPLE_ENABLED\")) {
		if (this.data.pending) {
			return {
				reply: \"Someone else is using the TTS right now, and multiple TTS is not available right now!\",
				cooldown: { length: 2500 }
			};
		}

		this.data.pending = true;
	}

	const partCheck = (string) => string.match(/^(voice|lang):\\w+$/);
	const limit = sb.Config.get(\"TTS_TIME_LIMIT\");
	const voiceData = sb.Config.get(\"TTS_VOICE_DATA\");
	const availableVoices = voiceData.map(i => i.name.toLowerCase());
	const voiceMap = Object.fromEntries(voiceData.map(i => [i.name, i.id]));
	const ttsData = [];
	let currentVoice = \"Brian\";
	let currentText = [];

	for (const token of args) {
		if (partCheck(token)) {
			let newVoice = null;
			let [type, param] = token.split(\":\");
			if (!type || !param) {
				this.data.pending = false;
				return {
					reply: `Incorrect format provided! Use (voice|lang):(name) instead.`
				};
			}

			param = param.toLowerCase();

			if (type === \"lang\") {
				const filtered = voiceData.filter(i => i.lang.toLowerCase().includes(param));
				if (filtered.length === 0) {
					this.data.pending = false;
					return {
						reply: `Language not found: ${param}`
					};
				}

				newVoice = sb.Utils.randArray(filtered).name;
			}
			else if (type === \"voice\") {
				if (param === \"random\") {
					param = sb.Utils.randArray(availableVoices);
				}

				if (!availableVoices.includes(param)) {
					this.data.pending = false;
					return {
						reply: `Voice not found: ${param}`,
						cooldown: { length: 2500 }
					};
				}

				newVoice = sb.Utils.capitalize(param);
			}

			if (newVoice !== currentVoice)  {
				if (currentText.length > 0) {
					ttsData.push({
						voice: currentVoice,
						text: currentText.join(\" \")
					});
				}

				currentVoice = newVoice;
				currentText = [];
			}
		}
		else {
			currentText.push(token);
		}
	}

	ttsData.push({
		voice: currentVoice,
		text: currentText.join(\" \")
	});

	if (ttsData.length > 3) {
		this.data.pending = false;
		return {
			reply: `Your TTS was refused! You used too many voices - ${ttsData.length}, but the maximum is 3.`,
			cooldown: { length: 5000 }
		};
	}

	for (const record of ttsData) {
		record.voice = voiceMap[record.voice];
	}

	let messageTime = 0n;
	let result = null;
	try {
		messageTime = process.hrtime.bigint();
		result = await sb.LocalRequest.playTextToSpeech({
			tts: ttsData,
			volume: sb.Config.get(\"TTS_VOLUME\"),
			limit: sb.Config.get(\"TTS_TIME_LIMIT\")
		});
		messageTime = process.hrtime.bigint() - messageTime;
	}
	catch (e) {
		console.log(e);
		await sb.Config.set(\"TTS_ENABLED\", false);
		return {
			reply: \"TTS Listener encountered an error or is turned on. Turning off text to speech!\"
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
	let cooldown = (duration > 10000)
		? (context.command.Cooldown + (duration - 10000) * 10) * (ttsData.length)
		: context.command.Cooldown;

	return {
		reply: `Your message has been succesfully played on TTS! It took ${duration / 1000} seconds to read out, and your cooldown is ${cooldown / 1000} seconds.`,
		cooldown: {
			length: cooldown
		}
	};
})'