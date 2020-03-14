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
		NULL,
		'(async function time (context, ...args) {
	let skipLocation = false;

	if (args.length === 0) {
		if (context.user.Data.defaultLocation) {
			args = context.user.Data.defaultLocation.address;
			skipLocation = context.user.Data.defaultLocation.private;
		}
		else {
			return {
				reply: \"You must search for something first!\",
				cooldown: { length: 2500 }
			};
		}
	}
	else if (args[0].toLowerCase().replace(/^@/, \"\") === sb.Config.get(\"SELF\")) {
		return {
			reply: \"🤖 My current time: \" + sb.Date.now() + \" 🤖\"
		};
	}
	else if (args[0].startsWith(\"@\") ) {
		const targetUser = await sb.User.get(args[0]);
		if (!targetUser) {
			return {
				reply: \"That user does not exist!\",
				cooldown: { length: 2500 }
			};
		}
		else if (!targetUser.Data.defaultLocation) {
			return {
				reply: \"That user has not set their default location!\",
				cooldown: { length: 2500 }
			};
		}
		else {
			args = targetUser.Data.defaultLocation.address;
			skipLocation = targetUser.Data.defaultLocation.private;
		}
	}

	const place = args.join(\" \");
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
		let extra = \"\";

		if (prettyOffset[0] !== \"-\") {
			prettyOffset = \"+\" + prettyOffset;
		}

		if (timezone.Abbreviation === \"UTC\") {
			extra = \"JUST 4Head\";
			prettyOffset = \"\";
		}

		const date = new sb.Date().setTimezoneOffset(timezone.Offset * 60).format(\"H:i (Y-m-d)\");
		return {
			reply: `TIMEZONEDETECTED ${timezone.Abbreviation} is ${timezone.Name}, which is ${extra} UTC${prettyOffset} and it is ${date} there right now.`
		};
	}

	const { results: [geoData] } = await sb.Got.instances.Google({
		url: \"geocode/json\",
		searchParams: new sb.URLParams()
			.set(\"address\", place)
			.set(\"key\", sb.Config.get(\"API_GOOGLE_GEOCODING\"))
			.toString()
	}).json();

	if (!geoData) {
		return { reply: \"No place matching that query has been found!\" };
	}

	const timeData = await sb.Got.instances.Google({
		url: \"timezone/json\",
		searchParams: new sb.URLParams()
			.set(\"timestamp\", Math.trunc(sb.Date.now() / 1000).toString())
			.set(\"location\", geoData.geometry.location.lat + \",\" + geoData.geometry.location.lng)
			.set(\"key\", sb.Config.get(\"API_GOOGLE_TIMEZONE\"))
			.toString()
	}).json();

	if (timeData.status === \"ZERO_RESULTS\") {
		return { reply: \"Target place is ambiguous - it contains more than one timezone\\)!\" };
	}

	const totalOffset = (timeData.rawOffset + timeData.dstOffset);
	const offset = (totalOffset >= 0 ? \"+\" : \"-\") + Math.trunc(Math.abs(totalOffset) / 3600) + \":\" + sb.Utils.zf((Math.abs(totalOffset) % 3600) / 60, 2);

	const time = new sb.Date();
	time.setTimezoneOffset(totalOffset / 60);

	const replyPlace = (skipLocation) ? \"(location hidden)\" : place;
	return {
		reply: `${replyPlace} is currently observing ${timeData.timeZoneName}, which is UTC${offset}, and it\'s ${time.format(\"H:i (Y-m-d)\")} there right now.`
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function time (context, ...args) {
	let skipLocation = false;

	if (args.length === 0) {
		if (context.user.Data.defaultLocation) {
			args = context.user.Data.defaultLocation.address;
			skipLocation = context.user.Data.defaultLocation.private;
		}
		else {
			return {
				reply: \"You must search for something first!\",
				cooldown: { length: 2500 }
			};
		}
	}
	else if (args[0].toLowerCase().replace(/^@/, \"\") === sb.Config.get(\"SELF\")) {
		return {
			reply: \"🤖 My current time: \" + sb.Date.now() + \" 🤖\"
		};
	}
	else if (args[0].startsWith(\"@\") ) {
		const targetUser = await sb.User.get(args[0]);
		if (!targetUser) {
			return {
				reply: \"That user does not exist!\",
				cooldown: { length: 2500 }
			};
		}
		else if (!targetUser.Data.defaultLocation) {
			return {
				reply: \"That user has not set their default location!\",
				cooldown: { length: 2500 }
			};
		}
		else {
			args = targetUser.Data.defaultLocation.address;
			skipLocation = targetUser.Data.defaultLocation.private;
		}
	}

	const place = args.join(\" \");
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
		let extra = \"\";

		if (prettyOffset[0] !== \"-\") {
			prettyOffset = \"+\" + prettyOffset;
		}

		if (timezone.Abbreviation === \"UTC\") {
			extra = \"JUST 4Head\";
			prettyOffset = \"\";
		}

		const date = new sb.Date().setTimezoneOffset(timezone.Offset * 60).format(\"H:i (Y-m-d)\");
		return {
			reply: `TIMEZONEDETECTED ${timezone.Abbreviation} is ${timezone.Name}, which is ${extra} UTC${prettyOffset} and it is ${date} there right now.`
		};
	}

	const { results: [geoData] } = await sb.Got.instances.Google({
		url: \"geocode/json\",
		searchParams: new sb.URLParams()
			.set(\"address\", place)
			.set(\"key\", sb.Config.get(\"API_GOOGLE_GEOCODING\"))
			.toString()
	}).json();

	if (!geoData) {
		return { reply: \"No place matching that query has been found!\" };
	}

	const timeData = await sb.Got.instances.Google({
		url: \"timezone/json\",
		searchParams: new sb.URLParams()
			.set(\"timestamp\", Math.trunc(sb.Date.now() / 1000).toString())
			.set(\"location\", geoData.geometry.location.lat + \",\" + geoData.geometry.location.lng)
			.set(\"key\", sb.Config.get(\"API_GOOGLE_TIMEZONE\"))
			.toString()
	}).json();

	if (timeData.status === \"ZERO_RESULTS\") {
		return { reply: \"Target place is ambiguous - it contains more than one timezone\\)!\" };
	}

	const totalOffset = (timeData.rawOffset + timeData.dstOffset);
	const offset = (totalOffset >= 0 ? \"+\" : \"-\") + Math.trunc(Math.abs(totalOffset) / 3600) + \":\" + sb.Utils.zf((Math.abs(totalOffset) % 3600) / 60, 2);

	const time = new sb.Date();
	time.setTimezoneOffset(totalOffset / 60);

	const replyPlace = (skipLocation) ? \"(location hidden)\" : place;
	return {
		reply: `${replyPlace} is currently observing ${timeData.timeZoneName}, which is UTC${offset}, and it\'s ${time.format(\"H:i (Y-m-d)\")} there right now.`
	};
})'