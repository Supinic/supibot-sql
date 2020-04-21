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
		60,
		'stream',
		NULL,
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
		0,
		NULL,
		'(async function stream (context, type, ...rest) {
	if (!type) {
		return { reply: \"Pick a command first.\" };
	}

	type = type.toLowerCase();
	switch (type) {
		case \"game\":
		case \"status\":
		case \"title\": {
			let setType = type;
			if (setType === \"title\") {
				setType = \"status\";
			}

			const channelID = await sb.Utils.getTwitchID(\"supinic\");
			const { body, statusCode } = await sb.Got.instances.Twitch.Kraken({
				method: \"PUT\",
				url: \"channels/\" + channelID,
				headers: {
					\"Authorization\": \"OAuth \" + sb.Config.get(\"TWITCH_OAUTH_EDITOR\")
				},
				json: {
					channel: {
						[setType]: rest.join(\" \")
					}
				},
				throwHttpErrors: false,
				resolveBodyOnly: false
			});

			if (statusCode !== 200) {
				const { status, error, message } = JSON.parse(body.message);
				return {
					reply: `Twitch API Error - ${status} ${error}: ${message}`
				};
			}

			return {
				reply: sb.Utils.capitalize(setType) + \" set successfully.\"
			};
		}

		case \"tts\": {
			const value = (rest.shift() === \"true\");
			sb.Config.set(\"TTS_ENABLED\", value ? \"1\" : \"0\");
			return { reply: \"Text to speech is now set to \" + value + \".\" };
		}

		case \"ttslimit\": {
			const limit = Number(rest.shift());
			if (!Number.isFinite(limit) || limit < 0 || limit > 300.0e3) {
				return {
					reply: \"Invalid value provided! Must be in the range <0, 300000>.\"
				};
			}

			sb.Config.set(\"TTS_TIME_LIMIT\", limit);
			return { reply: \"Text to speech time limit is now set to \" + limit + \" milliseconds.\" };
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
			if (![\"off\", \"vlc\", \"cytube\", \"dubtrack\", \"necrodancer\", \"vlc-read\"].includes(value)) {
				return { reply: \"Invalid song request state!\" };
			}

			sb.Config.set(\"SONG_REQUESTS_STATE\", value);
			return { reply: \"Song requests are now set to \" + value };
		}

		default: return { reply: \"Unrecognized command.\" };
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

	type = type.toLowerCase();
	switch (type) {
		case \"game\":
		case \"status\":
		case \"title\": {
			let setType = type;
			if (setType === \"title\") {
				setType = \"status\";
			}

			const channelID = await sb.Utils.getTwitchID(\"supinic\");
			const { body, statusCode } = await sb.Got.instances.Twitch.Kraken({
				method: \"PUT\",
				url: \"channels/\" + channelID,
				headers: {
					\"Authorization\": \"OAuth \" + sb.Config.get(\"TWITCH_OAUTH_EDITOR\")
				},
				json: {
					channel: {
						[setType]: rest.join(\" \")
					}
				},
				throwHttpErrors: false,
				resolveBodyOnly: false
			});

			if (statusCode !== 200) {
				const { status, error, message } = JSON.parse(body.message);
				return {
					reply: `Twitch API Error - ${status} ${error}: ${message}`
				};
			}

			return {
				reply: sb.Utils.capitalize(setType) + \" set successfully.\"
			};
		}

		case \"tts\": {
			const value = (rest.shift() === \"true\");
			sb.Config.set(\"TTS_ENABLED\", value ? \"1\" : \"0\");
			return { reply: \"Text to speech is now set to \" + value + \".\" };
		}

		case \"ttslimit\": {
			const limit = Number(rest.shift());
			if (!Number.isFinite(limit) || limit < 0 || limit > 300.0e3) {
				return {
					reply: \"Invalid value provided! Must be in the range <0, 300000>.\"
				};
			}

			sb.Config.set(\"TTS_TIME_LIMIT\", limit);
			return { reply: \"Text to speech time limit is now set to \" + limit + \" milliseconds.\" };
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
			if (![\"off\", \"vlc\", \"cytube\", \"dubtrack\", \"necrodancer\", \"vlc-read\"].includes(value)) {
				return { reply: \"Invalid song request state!\" };
			}

			sb.Config.set(\"SONG_REQUESTS_STATE\", value);
			return { reply: \"Song requests are now set to \" + value };
		}

		default: return { reply: \"Unrecognized command.\" };
	}
})'