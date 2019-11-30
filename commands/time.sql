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
		28,
		'time',
		NULL,
		'Fetches the current time and timezone for a given location',
		10000,
		0,
		0,
		0,
		0,
		NULL,
		0,
		0,
		0,
		1,
		1,
		0,
		'(async function time (context, ...args) {
	const place = args.join(\" \");
	if (!place) {
		return {
			reply: \"You must search for something first!\",
			meta: { skipCooldown: true }
		};
	}
	else if (place.toLowerCase() === sb.Config.get(\"SELF\")) {
		return { reply: \"🤖 My current time: \" + sb.Date.now() + \" 🤖\" };
	}

	const timezone = await sb.Query.getRecordset(rs => rs
		.select(\"Abbreviation\", \"Offset\", \"Name\")
		.from(\"data\", \"Timezone\")
		.where(\"Abbreviation = %s\", place)
		.limit(1)
		.single()
	);
	if (timezone) {
		const extraOffset = (Math.trunc(timezone.Offset) - timezone.Offset) * 60;
		let prettyOffset = (\"00\" + String(Math.trunc(timezone.Offset))).slice(-2) + \":\" + (\"00\" + extraOffset).slice(-2);
		if (prettyOffset[0] !== \"-\") {
			prettyOffset = \"+\" + prettyOffset;
		}

		const date = new sb.Date().setTimezoneOffset(timezone.Offset * 60).format(\"H:i (Y-m-d)\");

		return { 
			reply: \"Timezone detected! \"
				+ timezone.Abbreviation 
				+ \" is \" 
				+ timezone.Name 
				+ \", which is UTC\" 
				+ prettyOffset 
				+ \", and it is \" 
				+ date 
				+ \" there right now.\" 
		};
	}

	const geoData = (await sb.Utils.fetchGeoLocationData(place, sb.Config.get(\"API_GOOGLE_GEOCODING\"))).results[0];
	if (!geoData) {
		return { reply: \"No place matching that query has been found!\" };
	}

	const timestamp = Math.trunc(sb.Date.now() / 1000);
	const coordinates = geoData.geometry.location.lat + \",\" + geoData.geometry.location.lng;

	const url = [
		\"https://maps.googleapis.com/maps/api/timezone/json\",
		\"?key=\" + sb.Config.get(\"API_GOOGLE_TIMEZONE\"),
		\"&timestamp=\" + timestamp,
		\"&location=\" + coordinates
	].join(\"\");

	const timeData = JSON.parse(await sb.Utils.request(url));
	if (timeData.status === \"ZERO_RESULTS\") {
		return { reply: \"Target place is too ambiguous (it contains more than one timezone)!\" };
	}

	const totalOffset = (timeData.rawOffset + timeData.dstOffset);
	const offset = (totalOffset >= 0 ? \"+\" : \"-\") + Math.trunc(Math.abs(totalOffset) / 3600) + \":\" + sb.Utils.zf((Math.abs(totalOffset) % 3600) / 60, 2);

	const time = new sb.Date();
	time.setTimezoneOffset(totalOffset / 60);
	const reply = [
		place + \" is currently observing \" + timeData.timeZoneName,
		\"which is GMT\" + offset,
		\"and it\'s \" + time.format(\"H:i (Y-m-d)\") + \" there right now.\"
	];

	return { reply: reply.join(\", \") };
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function time (context, ...args) {
	const place = args.join(\" \");
	if (!place) {
		return {
			reply: \"You must search for something first!\",
			meta: { skipCooldown: true }
		};
	}
	else if (place.toLowerCase() === sb.Config.get(\"SELF\")) {
		return { reply: \"🤖 My current time: \" + sb.Date.now() + \" 🤖\" };
	}

	const timezone = await sb.Query.getRecordset(rs => rs
		.select(\"Abbreviation\", \"Offset\", \"Name\")
		.from(\"data\", \"Timezone\")
		.where(\"Abbreviation = %s\", place)
		.limit(1)
		.single()
	);
	if (timezone) {
		const extraOffset = (Math.trunc(timezone.Offset) - timezone.Offset) * 60;
		let prettyOffset = (\"00\" + String(Math.trunc(timezone.Offset))).slice(-2) + \":\" + (\"00\" + extraOffset).slice(-2);
		if (prettyOffset[0] !== \"-\") {
			prettyOffset = \"+\" + prettyOffset;
		}

		const date = new sb.Date().setTimezoneOffset(timezone.Offset * 60).format(\"H:i (Y-m-d)\");

		return { 
			reply: \"Timezone detected! \"
				+ timezone.Abbreviation 
				+ \" is \" 
				+ timezone.Name 
				+ \", which is UTC\" 
				+ prettyOffset 
				+ \", and it is \" 
				+ date 
				+ \" there right now.\" 
		};
	}

	const geoData = (await sb.Utils.fetchGeoLocationData(place, sb.Config.get(\"API_GOOGLE_GEOCODING\"))).results[0];
	if (!geoData) {
		return { reply: \"No place matching that query has been found!\" };
	}

	const timestamp = Math.trunc(sb.Date.now() / 1000);
	const coordinates = geoData.geometry.location.lat + \",\" + geoData.geometry.location.lng;

	const url = [
		\"https://maps.googleapis.com/maps/api/timezone/json\",
		\"?key=\" + sb.Config.get(\"API_GOOGLE_TIMEZONE\"),
		\"&timestamp=\" + timestamp,
		\"&location=\" + coordinates
	].join(\"\");

	const timeData = JSON.parse(await sb.Utils.request(url));
	if (timeData.status === \"ZERO_RESULTS\") {
		return { reply: \"Target place is too ambiguous (it contains more than one timezone)!\" };
	}

	const totalOffset = (timeData.rawOffset + timeData.dstOffset);
	const offset = (totalOffset >= 0 ? \"+\" : \"-\") + Math.trunc(Math.abs(totalOffset) / 3600) + \":\" + sb.Utils.zf((Math.abs(totalOffset) % 3600) / 60, 2);

	const time = new sb.Date();
	time.setTimezoneOffset(totalOffset / 60);
	const reply = [
		place + \" is currently observing \" + timeData.timeZoneName,
		\"which is GMT\" + offset,
		\"and it\'s \" + time.format(\"H:i (Y-m-d)\") + \" there right now.\"
	];

	return { reply: reply.join(\", \") };
})'