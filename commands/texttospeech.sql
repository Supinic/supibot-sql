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
		Dynamic_Description
	)
VALUES
	(
		86,
		'texttospeech',
		'[\"tts\"]',
		'ping,pipe,skip-banphrase',
		'Plays TTS on stream, if enabled. You can specify voice by using \"voice:<name>\" or \"lang:<language>\" anywhere in your message. Available voices: https://supinic.com/stream/tts',
		10000,
		NULL,
		'(() => {
	const limit = 30_000;
	const partsLimit = 5;

	return {
		limit,
		partsLimit,
		maxCooldown: (this.Cooldown + (limit - 10000) * 10)
	};
})()',
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
	const voiceData = sb.Config.get(\"TTS_VOICE_DATA\");
	const availableVoices = voiceData.map(i => i.name.toLowerCase());
	const voiceMap = Object.fromEntries(voiceData.map(i => [i.name, i.id]));
	
	let ttsData = [];
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
						name: currentVoice,
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
		name: currentVoice,
		voice: currentVoice,
		text: currentText.join(\" \")
	});
	
	ttsData = ttsData.filter(i => i.text.length > 0);

	if (ttsData.length > this.staticData.partsLimit) {
		this.data.pending = false;
		return {
			reply: `Your TTS was refused! You used too many voices - ${ttsData.length}, but the maximum is ${this.staticData.partsLimit}.`,
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
			limit: this.staticData.limit
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
			reply: `Your TTS was refused, because its length exceeded the limit of ${this.staticData.limit / 1000} seconds!`,
			cooldown: { length: 5000 }
		};
	}

	const duration = sb.Utils.round(Number(messageTime) / 1.0e6, 0);
	let cooldown = (duration > 10000)
		? (context.command.Cooldown + (duration - 10000) * 10) * (ttsData.length)
		: context.command.Cooldown;

	if (cooldown > this.staticData.maxCooldown) {
		cooldown = this.staticData.maxCooldown;
	}

	const randomVoicesString = `You used these voices: ${ttsData.map(i => i.name).join(\", \")}.`;
	return {
		reply: `Your message has been succesfully played on TTS! It took ${duration / 1000} seconds to read out, and your cooldown is ${cooldown / 1000} seconds. ${randomVoicesString}`,
		cooldown: {
			length: cooldown
		}
	};
})',
		'(async (prefix, values) => {
	const { partsLimit } = values.getStaticData();

	return [
		\"Plays your messages as TTS on supinic\'s stream, if enabled.\",
		\"You can specify a voice to have it say your message. If you don\'t specify, Brian is used by default\",
		\"You can also specify a language (full name, or ISO code), in which case a random voice for the given language will be chosen for you.\",
		\"If you use multiple voices, each part of the message will be read out by different voices.\",
		\"\",

		`<code>${prefix}tts This is a message.</code>`,
		\"Plays the TTS using Brian.\",
		\"\",

		`<code>${prefix}tts voice:Giorgio Questo è un messaggio.</code>`,
		\"Plays the TTS using Giorgio.\",
		\"\",

		`<code>${prefix}tts lang:french Ceci est un message.</code>`,
		\"Plays the TTS using a random French voice.\",
		\"\",

		`<code>${prefix}tts lang:fr Ceci est un message.</code>`,
		\"Plays the TTS, same as above (uses ISO code for French \'fr\').\",
		\"\",

		`<code>${prefix}tts voice:Brian Hello there. voice:Emilie Comment ça va? voice:Jacek Co mówisz?</code>`,
		\"Plays the TTS using three voices for each message part.\",
		\"The voice name has to be specified before (!) the actual message.\",
		\"Be warned - there is a limit of how many parts of tts you can use in one command!\",
		`Current limit: ${partsLimit} voices per message`
	];
})'
	)