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
		94,
		'playsound',
		'[\"ps\"]',
		'Plays a sound on supinic stream, if enabled. Use \"list\" as an argument to see the list of available playsounds.',
		10000,
		0,
		0,
		0,
		1,
		NULL,
		0,
		0,
		0,
		1,
		1,
		0,
		'(async function playSound (context, playsound) {
	if (!sb.Config.get(\"PLAYSOUNDS_ENABLED\")) {
		return { reply: \"Playsounds are currently disabled!\" };
	}

	else if (!playsound || playsound === \"list\") {
		return { reply: \"Currently available playsounds: https://supinic.com/bot/playsound\"};
	}

	const data = (await sb.Query.getRecordset(rs => rs
		.select(\"Filename\")
		.from(\"data\", \"Playsound\")
		.where(\"Name = %s\", playsound.toLowerCase())
		.where(\"Access = %s\", \"Everyone\")
	))[0];

	if (!data) {
		return {
			reply: \"That playsound either doesn\'t exist or is not available!\",
			meta: { skipCooldown: true }
		};
	}

	const result = await sb.LocalRequest.playAudio(data.Filename);
	if (typeof result === \"number\") {
		return {
			reply: \"The playsound\'s cooldown has not passed yet! Try again in \" + sb.Utils.timeDelta(sb.Date.now() + result),
			meta: { skipCooldown: true }
		};
	}
	else {
		return {
			reply: \"Your playsound has been played correctly on stream!\"
		};
	}
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function playSound (context, playsound) {
	if (!sb.Config.get(\"PLAYSOUNDS_ENABLED\")) {
		return { reply: \"Playsounds are currently disabled!\" };
	}

	else if (!playsound || playsound === \"list\") {
		return { reply: \"Currently available playsounds: https://supinic.com/bot/playsound\"};
	}

	const data = (await sb.Query.getRecordset(rs => rs
		.select(\"Filename\")
		.from(\"data\", \"Playsound\")
		.where(\"Name = %s\", playsound.toLowerCase())
		.where(\"Access = %s\", \"Everyone\")
	))[0];

	if (!data) {
		return {
			reply: \"That playsound either doesn\'t exist or is not available!\",
			meta: { skipCooldown: true }
		};
	}

	const result = await sb.LocalRequest.playAudio(data.Filename);
	if (typeof result === \"number\") {
		return {
			reply: \"The playsound\'s cooldown has not passed yet! Try again in \" + sb.Utils.timeDelta(sb.Date.now() + result),
			meta: { skipCooldown: true }
		};
	}
	else {
		return {
			reply: \"Your playsound has been played correctly on stream!\"
		};
	}
})'