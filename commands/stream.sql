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
		60,
		'stream',
		NULL,
		'Multiple configurations regarding the stream. Mostly used for #supinic, and nobody else.',
		0,
		0,
		1,
		0,
		1,
		NULL,
		0,
		0,
		0,
		1,
		1,
		0,
		'(async function stream (context, type, ...rest) {
	if (!type) {
		return { reply: \"Pick a command first.\" };
	}

	const cmd = type.toLowerCase();
	const url = {
		updateChannel: \"https://api.twitch.tv/kraken/channels/\" + sb.Config.get(\"TWITCH_CHANNEL_ID\") + \"?api_version=5\",
		knownBot: \"https://api.twitch.tv/kraken/users/68136884/chat?api_version=5&client_id=\" + sb.Config.get(\"TWITCH_CLIENT_ID\")
	};

	let targetURL = null;
	let data = null;
	let method = null;
	let success = null;

	switch (cmd) {
		case \"game\":
			targetURL= url.updateChannel;
			method = \"PUT\";
			data = { channel: { game: rest.join(\" \") }};
			success = \"Game set successfully.\";
			break;

		case \"status\":
		case \"title\":
			targetURL = url.updateChannel;
			method = \"PUT\";
			data = { channel: { status: rest.join(\" \") }};
			success = \"Status set successfully.\";
			break;

		case \"tts\": {
			const value = (rest.shift() === \"true\");
			sb.Config.set(\"TTS_ENABLED\", value ? \"1\" : \"0\");
			return { reply: \"Text to speech is now set to \" + value };
		}

		case \"ttsvolume\": {
			const volume = Number(rest.shift());
			if (!Number.isFinite(volume) || volume < 0 || volume > 8) {
				return {
					reply: \"Invalid value provided! Must be in the range <0, 8>.\"
				};
			}

			sb.Config.set(\"TTS_VOLUME\", volume);
			return { reply: \"Text to speech volume is now set to \" + volume };
		}

		case \"ttsmulti\":
		case \"multitts\": {
			const value = (rest.shift() === \"true\");
			sb.Config.set(\"TTS_MULTIPLE_ENABLED\", value ? \"1\" : \"0\");
			return { reply: \"Concurrent text to speech is now set to \" + value };
		}

		case \"ps\":
		case \"playsounds\":
		case \"playsound\": {
			const value = (rest.shift() === \"true\");
			sb.Config.set(\"PLAYSOUNDS_ENABLED\", value ? \"1\" : \"0\");
			return { reply: \"Play sounds are now set to \" + value };
		}

		case \"sr\": {
			const value = (rest.shift() || \"\").toLowerCase();
			if (![\"off\", \"vlc\", \"cytube\", \"dubtrack\", \"necrodancer\"].includes(value)) {
				return { reply: \"Invalid song request state!\" };
			}

			sb.Config.set(\"SONG_REQUESTS_STATE\", value);
			return { reply: \"Song requests are now set to \" + value };
		}

		default: return { reply: \"Unrecognized command.\" };
	}

	try {
		await sb.Utils.request({
			url: targetURL,
			method: method,
			headers: {
				\"Content-Type\": \"application/json\",
				\"Client-ID\": sb.Config.get(\"TWITCH_CLIENT_ID\"),
				\"Authorization\": \"OAuth \" + sb.Config.get(\"TWITCH_OAUTH_EDITOR\"),
				\"Accept\": \"application/vnd.twitchtv.v5+json\"
			},
			body: JSON.stringify(data)
		});

		return { reply: success };
	}
	catch (e) {
		console.log(e);
		sb.SystemLogger.send(\"Command.Error\", e.toString());
		return { reply: \"Something went wrong.\" };
	}
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function stream (context, type, ...rest) {
	if (!type) {
		return { reply: \"Pick a command first.\" };
	}

	const cmd = type.toLowerCase();
	const url = {
		updateChannel: \"https://api.twitch.tv/kraken/channels/\" + sb.Config.get(\"TWITCH_CHANNEL_ID\") + \"?api_version=5\",
		knownBot: \"https://api.twitch.tv/kraken/users/68136884/chat?api_version=5&client_id=\" + sb.Config.get(\"TWITCH_CLIENT_ID\")
	};

	let targetURL = null;
	let data = null;
	let method = null;
	let success = null;

	switch (cmd) {
		case \"game\":
			targetURL= url.updateChannel;
			method = \"PUT\";
			data = { channel: { game: rest.join(\" \") }};
			success = \"Game set successfully.\";
			break;

		case \"status\":
		case \"title\":
			targetURL = url.updateChannel;
			method = \"PUT\";
			data = { channel: { status: rest.join(\" \") }};
			success = \"Status set successfully.\";
			break;

		case \"tts\": {
			const value = (rest.shift() === \"true\");
			sb.Config.set(\"TTS_ENABLED\", value ? \"1\" : \"0\");
			return { reply: \"Text to speech is now set to \" + value };
		}

		case \"ttsvolume\": {
			const volume = Number(rest.shift());
			if (!Number.isFinite(volume) || volume < 0 || volume > 8) {
				return {
					reply: \"Invalid value provided! Must be in the range <0, 8>.\"
				};
			}

			sb.Config.set(\"TTS_VOLUME\", volume);
			return { reply: \"Text to speech volume is now set to \" + volume };
		}

		case \"ttsmulti\":
		case \"multitts\": {
			const value = (rest.shift() === \"true\");
			sb.Config.set(\"TTS_MULTIPLE_ENABLED\", value ? \"1\" : \"0\");
			return { reply: \"Concurrent text to speech is now set to \" + value };
		}

		case \"ps\":
		case \"playsounds\":
		case \"playsound\": {
			const value = (rest.shift() === \"true\");
			sb.Config.set(\"PLAYSOUNDS_ENABLED\", value ? \"1\" : \"0\");
			return { reply: \"Play sounds are now set to \" + value };
		}

		case \"sr\": {
			const value = (rest.shift() || \"\").toLowerCase();
			if (![\"off\", \"vlc\", \"cytube\", \"dubtrack\", \"necrodancer\"].includes(value)) {
				return { reply: \"Invalid song request state!\" };
			}

			sb.Config.set(\"SONG_REQUESTS_STATE\", value);
			return { reply: \"Song requests are now set to \" + value };
		}

		default: return { reply: \"Unrecognized command.\" };
	}

	try {
		await sb.Utils.request({
			url: targetURL,
			method: method,
			headers: {
				\"Content-Type\": \"application/json\",
				\"Client-ID\": sb.Config.get(\"TWITCH_CLIENT_ID\"),
				\"Authorization\": \"OAuth \" + sb.Config.get(\"TWITCH_OAUTH_EDITOR\"),
				\"Accept\": \"application/vnd.twitchtv.v5+json\"
			},
			body: JSON.stringify(data)
		});

		return { reply: success };
	}
	catch (e) {
		console.log(e);
		sb.SystemLogger.send(\"Command.Error\", e.toString());
		return { reply: \"Something went wrong.\" };
	}
})'