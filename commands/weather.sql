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
		39,
		'weather',
		NULL,
		'Fetches the current weather in a given location. You can add \"hour+#\" or \"day+#\" at the end for hourly/daily forecast, or \"week\" at the end for a weekly summary. Powered by Darksky.',
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
		'(async function weather (context, ...args) {
	let skipLocation = false;

	if (args.length === 0) {
		if (context.user.Data.defaultLocation) {
			skipLocation = context.user.Data.defaultLocation.private;
			args = context.user.Data.defaultLocation.address;
		}
		else {
			return {
				reply: \"No place has been provided!\",
				meta: { skipCooldown: true }
			};
		}
	}
	else if (args[0].startsWith(\"@\")) {
		const userData = await sb.User.get(args[0]);
		if (!userData) {
			return {
				reply: \"Invalid user provided!\"
			};
		}
		else if (!userData.Data.defaultLocation) {
			return {
				reply: \"That user did not set their default location!\"
			};
		}
		else {
			skipLocation = userData.Data.defaultLocation.private;
			args = args.slice(1);
			args.unshift(...userData.Data.defaultLocation.address);
		}
	}
	else if (args[0].toLowerCase() === \"supibot\") {
		const exec = require(\"child_process\").execSync;
		const temperature = exec(\"/opt/vc/bin/vcgencmd measure_temp\").toString().match(/([\\d\\.]+)/)[1] + \"°C\";

		return { 
			reply: \"Supibot, Supinic\'s table, Raspberry Pi 3B: \" + temperature + \". No wind detected. No precipitation expected.\" 
		};
	}
	else if (args[0] === \"set\" && args[1] === \"location\") {
		args = args.slice(2);
		let privateLocation = false;

		if (args[0] === \"private\") {
			args = args.slice(1);
			privateLocation = true;
		}

		if (args.length === 0) {
			return {
				reply: \"No default location provided!\"
			};
		}

		const check = (await sb.Command.get(\"weather\").execute(context, ...args)).reply;
		if (!check || !check.includes(\"(now)\")) {
			return {
				reply: \"Your location must be valid, and contain no extra arguments!\"
			};
		}

		context.user.Data.defaultLocation = {
			address: args,
			private: privateLocation
		};
		await context.user.saveProperty(\"Data\", context.user.Data);

		return {
			reply: \"Default location has been set! Use $weather without parameters, it will now find your default location\'s weather.\"
		}
	}

	const icons = {
		\"clear-day\": \"🌞\",
		\"clear-night\": \"🌚\",
		\"rain\": \"🌧️\",
		\"snow\": \"🌨️\",
		\"sleet\": \"🌧️🌨️\",
		\"fog\": \"🌫️\",
		\"cloudy\": \"☁️\",
		\"partly-cloudy-day\": \"⛅\",
		\"partly-cloudy-night\": \"☁️\",
		\"hail\": \"☄️\",
		\"thunderstorm\": \"🌩️\",
		\"tornado\": \"🌪️\",
		\"wind\": \"💨\"
	};

	let number = null;
	let type = \"currently\";
	const weatherRegex = /(hour|day|week)(\\+?(\\d+))?$/;

	if (args[args.length - 1].includes(\"-\")) {
		return { reply: \"Checking for weather history is not currently implemented\" };
	}
	else if (weatherRegex.test(args[args.length - 1])) {
		const match = args.pop().match(weatherRegex);

		if (match[2]) { // +<number> = shift by X, used in daily/hourly
			number = Number(match[3]);
			type = (match[1] === \"day\") ? \"daily\" : (match[1] === \"hour\") ? \"hourly\" : null;

			if (!type || (type === \"daily\" && number > 7) || (type === \"hourly\" && number > 48)) {
				return { reply: \"Invalid combination of parameters!\" };
			}
		}
		else { // summary
			type = (match[1] === \"day\") ? \"hourly\" : (match[1] === \"hour\") ? \"minutely\" : \"daily\";
		}
	}

	const params = new sb.URLParams();
	params.set(\"key\", sb.Config.get(\"API_GOOGLE_GEOCODING\"))
		.set(\"address\", args.join(\" \"));

	const geoData = JSON.parse(await sb.Utils.request({
		url: \"https://maps.googleapis.com/maps/api/geocode/json?\" + params.toString()
	}));

	if (!geoData.results[0]) {
		return {
			reply: \"That place was not found FeelsBadMan\"
		};
	}

	const coords = geoData.results[0].geometry.location;
	const excluded = [\"currently\", \"minutely\", \"hourly\", \"daily\", \"alerts\"].filter(i => i !== type);
	const weatherURL = [
		\"https://api.darksky.net/forecast/\",
		sb.Config.get(\"API_DARKSKY\") + \"/\",
		coords.lat + \",\" + coords.lng + \"?\",
		new sb.URLParams()
			.set(\"units\", \"si\")
			.set(\"exclude\", excluded.join(\",\"))
			.toString()
	].join(\"\");

	let data = null;
	let message = null;
	const topData = JSON.parse(await sb.Utils.request(weatherURL));

	if (number === null && type !== \"currently\") {
		message = topData[type].summary;
	}
	else {
		data = (type === \"currently\")
			? topData.currently
			: topData[type].data[number];

		const icon = icons[data.icon];
		const precip = (data.precipProbability === 0)
			? \"No precipitation expected.\"
			: (sb.Utils.round(data.precipProbability * 100) + \"% chance of \" + sb.Utils.round(data.precipIntensity, 2) + \" mm \" + data.precipType + \".\");
		const temp = (type !== \"daily\")
			? (sb.Utils.round(data.temperature, 2) + \"°C\")
			: (\"Temperatures: \" + sb.Utils.round(data.temperatureMin) + \"°C to \" + sb.Utils.round(data.temperatureMax) + \"°C\");
		const storm = (type === \"currently\")
			? (typeof data.nearestStormDistance !== \"undefined\")
				? (\"Nearest storm is \" + data.nearestStormDistance + \" km away. \")
				: (\"No storms nearby. \")
			: \"\";

		message = (icon || data.icon) + \" \" + // data.summary + \". \" +
			temp + \". \" +
			((type === \"currently\") ? (\"Feels like \" + sb.Utils.round(data.apparentTemperature) + \"°C. \") : \"\") +
			storm +
			sb.Utils.round(data.cloudCover * 100) + \"% cloudy. \" +
			\"Wind gusts up to \" + sb.Utils.round(data.windGust * 3.6) + \" km/h. \" +
			sb.Utils.round(data.humidity * 100) + \"% humidity. \" +
			precip;
	}

	let plusTime = \"\";
	if (typeof number === \"number\") {
		const time = new sb.Date(topData[type].data[number].time * 1000).setTimezoneOffset(topData.offset * 60).addDays(-1);
		if (type === \"hourly\") {
			plusTime = \" (\" + time.format(\"H:00\") + \" local time)\";
		}
		else {
			plusTime = \" (\" + time.format(\"j.n.\") + \" local date)\";
		}
	}
	else if (type === \"currently\") {
		plusTime = \" (now)\";
	}
	else {
		plusTime = \" (\" + type + \" summary)\";
	}

	const place = (skipLocation)
		? \"(location hidden)\"
		: geoData.results[0].formatted_address;
	
	return {
		reply: `${place} ${plusTime}: ${message}`
	};
})',
		NULL,
		'(prefix) => [
	\"Checks for current weather or forecast\",
	\"\",
	`${prefix}weather New York => (current weather in NY)`,
	`${prefix}weather New York hour+1 => (weather forecast in 1 hour)`,
	`${prefix}weather New York day+1 => (weather forecast for tomorrow)`,
	`${prefix}weather New York week => (weather summary for upcoming week)`,
	\"\",
	`${prefix}weather set location (location) => sets default weather location for you - you can then use ${prefix}weather only`,
	`${prefix}weather set location private (location) => sets default weather location for you - but the location will be hidden`
]'
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function weather (context, ...args) {
	let skipLocation = false;

	if (args.length === 0) {
		if (context.user.Data.defaultLocation) {
			skipLocation = context.user.Data.defaultLocation.private;
			args = context.user.Data.defaultLocation.address;
		}
		else {
			return {
				reply: \"No place has been provided!\",
				meta: { skipCooldown: true }
			};
		}
	}
	else if (args[0].startsWith(\"@\")) {
		const userData = await sb.User.get(args[0]);
		if (!userData) {
			return {
				reply: \"Invalid user provided!\"
			};
		}
		else if (!userData.Data.defaultLocation) {
			return {
				reply: \"That user did not set their default location!\"
			};
		}
		else {
			skipLocation = userData.Data.defaultLocation.private;
			args = args.slice(1);
			args.unshift(...userData.Data.defaultLocation.address);
		}
	}
	else if (args[0].toLowerCase() === \"supibot\") {
		const exec = require(\"child_process\").execSync;
		const temperature = exec(\"/opt/vc/bin/vcgencmd measure_temp\").toString().match(/([\\d\\.]+)/)[1] + \"°C\";

		return { 
			reply: \"Supibot, Supinic\'s table, Raspberry Pi 3B: \" + temperature + \". No wind detected. No precipitation expected.\" 
		};
	}
	else if (args[0] === \"set\" && args[1] === \"location\") {
		args = args.slice(2);
		let privateLocation = false;

		if (args[0] === \"private\") {
			args = args.slice(1);
			privateLocation = true;
		}

		if (args.length === 0) {
			return {
				reply: \"No default location provided!\"
			};
		}

		const check = (await sb.Command.get(\"weather\").execute(context, ...args)).reply;
		if (!check || !check.includes(\"(now)\")) {
			return {
				reply: \"Your location must be valid, and contain no extra arguments!\"
			};
		}

		context.user.Data.defaultLocation = {
			address: args,
			private: privateLocation
		};
		await context.user.saveProperty(\"Data\", context.user.Data);

		return {
			reply: \"Default location has been set! Use $weather without parameters, it will now find your default location\'s weather.\"
		}
	}

	const icons = {
		\"clear-day\": \"🌞\",
		\"clear-night\": \"🌚\",
		\"rain\": \"🌧️\",
		\"snow\": \"🌨️\",
		\"sleet\": \"🌧️🌨️\",
		\"fog\": \"🌫️\",
		\"cloudy\": \"☁️\",
		\"partly-cloudy-day\": \"⛅\",
		\"partly-cloudy-night\": \"☁️\",
		\"hail\": \"☄️\",
		\"thunderstorm\": \"🌩️\",
		\"tornado\": \"🌪️\",
		\"wind\": \"💨\"
	};

	let number = null;
	let type = \"currently\";
	const weatherRegex = /(hour|day|week)(\\+?(\\d+))?$/;

	if (args[args.length - 1].includes(\"-\")) {
		return { reply: \"Checking for weather history is not currently implemented\" };
	}
	else if (weatherRegex.test(args[args.length - 1])) {
		const match = args.pop().match(weatherRegex);

		if (match[2]) { // +<number> = shift by X, used in daily/hourly
			number = Number(match[3]);
			type = (match[1] === \"day\") ? \"daily\" : (match[1] === \"hour\") ? \"hourly\" : null;

			if (!type || (type === \"daily\" && number > 7) || (type === \"hourly\" && number > 48)) {
				return { reply: \"Invalid combination of parameters!\" };
			}
		}
		else { // summary
			type = (match[1] === \"day\") ? \"hourly\" : (match[1] === \"hour\") ? \"minutely\" : \"daily\";
		}
	}

	const params = new sb.URLParams();
	params.set(\"key\", sb.Config.get(\"API_GOOGLE_GEOCODING\"))
		.set(\"address\", args.join(\" \"));

	const geoData = JSON.parse(await sb.Utils.request({
		url: \"https://maps.googleapis.com/maps/api/geocode/json?\" + params.toString()
	}));

	if (!geoData.results[0]) {
		return {
			reply: \"That place was not found FeelsBadMan\"
		};
	}

	const coords = geoData.results[0].geometry.location;
	const excluded = [\"currently\", \"minutely\", \"hourly\", \"daily\", \"alerts\"].filter(i => i !== type);
	const weatherURL = [
		\"https://api.darksky.net/forecast/\",
		sb.Config.get(\"API_DARKSKY\") + \"/\",
		coords.lat + \",\" + coords.lng + \"?\",
		new sb.URLParams()
			.set(\"units\", \"si\")
			.set(\"exclude\", excluded.join(\",\"))
			.toString()
	].join(\"\");

	let data = null;
	let message = null;
	const topData = JSON.parse(await sb.Utils.request(weatherURL));

	if (number === null && type !== \"currently\") {
		message = topData[type].summary;
	}
	else {
		data = (type === \"currently\")
			? topData.currently
			: topData[type].data[number];

		const icon = icons[data.icon];
		const precip = (data.precipProbability === 0)
			? \"No precipitation expected.\"
			: (sb.Utils.round(data.precipProbability * 100) + \"% chance of \" + sb.Utils.round(data.precipIntensity, 2) + \" mm \" + data.precipType + \".\");
		const temp = (type !== \"daily\")
			? (sb.Utils.round(data.temperature, 2) + \"°C\")
			: (\"Temperatures: \" + sb.Utils.round(data.temperatureMin) + \"°C to \" + sb.Utils.round(data.temperatureMax) + \"°C\");
		const storm = (type === \"currently\")
			? (typeof data.nearestStormDistance !== \"undefined\")
				? (\"Nearest storm is \" + data.nearestStormDistance + \" km away. \")
				: (\"No storms nearby. \")
			: \"\";

		message = (icon || data.icon) + \" \" + // data.summary + \". \" +
			temp + \". \" +
			((type === \"currently\") ? (\"Feels like \" + sb.Utils.round(data.apparentTemperature) + \"°C. \") : \"\") +
			storm +
			sb.Utils.round(data.cloudCover * 100) + \"% cloudy. \" +
			\"Wind gusts up to \" + sb.Utils.round(data.windGust * 3.6) + \" km/h. \" +
			sb.Utils.round(data.humidity * 100) + \"% humidity. \" +
			precip;
	}

	let plusTime = \"\";
	if (typeof number === \"number\") {
		const time = new sb.Date(topData[type].data[number].time * 1000).setTimezoneOffset(topData.offset * 60).addDays(-1);
		if (type === \"hourly\") {
			plusTime = \" (\" + time.format(\"H:00\") + \" local time)\";
		}
		else {
			plusTime = \" (\" + time.format(\"j.n.\") + \" local date)\";
		}
	}
	else if (type === \"currently\") {
		plusTime = \" (now)\";
	}
	else {
		plusTime = \" (\" + type + \" summary)\";
	}

	const place = (skipLocation)
		? \"(location hidden)\"
		: geoData.results[0].formatted_address;
	
	return {
		reply: `${place} ${plusTime}: ${message}`
	};
})'