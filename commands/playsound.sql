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
		94,
		'playsound',
		'[\"ps\"]',
		'ping,pipe,whitelist',
		'Plays a sound on supinic stream, if enabled. Use \"list\" as an argument to see the list of available playsounds.',
		10000,
		NULL,
		NULL,
		'(async function playSound (context, playsound) {
	if (!sb.Config.get(\"PLAYSOUNDS_ENABLED\")) {
		return { reply: \"Playsounds are currently disabled!\" };
	}

	else if (!playsound || playsound === \"list\") {
		return { reply: \"Currently available playsounds: https://supinic.com/stream/playsound/list\"};
	}

	const data = await sb.Query.getRecordset(rs => rs
		.select(\"Filename\")
		.from(\"data\", \"Playsound\")
		.where(\"Name = %s\", playsound.toLowerCase())
		.where(\"Access = %s\", \"Everyone\")
		.single()
	);

	if (!data) {
		return {
			reply: \"That playsound either doesn\'t exist or is not available!\",
			cooldown: null
		};
	}

	let result = null;
	try {
		result = await sb.LocalRequest.playAudio(data.Filename);
	}
	catch (e) {
		await sb.Config.set(\"PLAYSOUNDS_ENABLED\", false);
		return { reply: \"The desktop listener is not currently running, turning off playsounds!\" }
	}
	

	if (typeof result === \"number\") {
		return {
			reply: \"The playsound\'s cooldown has not passed yet! Try again in \" + sb.Utils.timeDelta(sb.Date.now() + result),
			cooldown: null
		};
	}
	else {
		return {
			reply: \"Your playsound has been played correctly on stream!\"
		};
	}
})',
		NULL
	)