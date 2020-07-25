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
		Dynamic_Description,
		Source
	)
VALUES
	(
		39,
		'weather',
		NULL,
		'mention,pipe',
		'Fetches the current weather in a given location. You can add \"hour+#\" or \"day+#\" at the end for hourly/daily forecast, or \"week\" at the end for a weekly summary. Powered by Darksky.',
		10000,
		NULL,
		'({
	icons: {
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
	}
})',
		'(async function weather (context, ...args) {
	let skipLocation = false;
	let coords = null;
	let formattedAddress = null;

	if (args.length === 0) {
		if (context.user.Data.location) {
			skipLocation = context.user.Data.location.hidden;
			coords = context.user.Data.location.coordinates;
			formattedAddress = context.user.Data.location.formatted;
		}
		else {
			return {
				reply: \"No place provided!\",
				cooldown: 2500
			};
		}
	}
	else if (args[0].toLowerCase().replace(/^@/, \"\") === \"supibot\") {
		const exec = require(\"child_process\").execSync;
		const temperature = exec(\"/opt/vc/bin/vcgencmd measure_temp\").toString().match(/([\\d\\.]+)/)[1] + \"°C\";

		return {
			reply: \"Supibot, Supinic\'s table, Raspberry Pi 3B: \" + temperature + \". No wind detected. No precipitation expected.\"
		};
	}
	else if (args[0].startsWith(\"@\")) {
		const userData = await sb.User.get(args[0]);
		if (!userData) {
			return {
				reply: \"Invalid user provided!\",
				cooldown: {
					length: 1000
				}
			};
		}
		else if (!userData.Data.location) {
			return {
				reply: \"That user did not set their location!\",
				cooldown: {
					length: 1000
				}
			};
		}
		else {
			coords = userData.Data.location.coordinates;
			skipLocation = userData.Data.location.hidden;
			formattedAddress = userData.Data.location.formatted;
		}
	}

	let number = null;
	let type = \"currently\";
	const weatherRegex = /\\b(hour|day|week)(\\+?(\\d+))?$/;

	if (args.length > 0) {
		if (args[args.length - 1].includes(\"-\")) {
			return { reply: \"Checking for weather history is not currently implemented\" };
		}
		else if (args && weatherRegex.test(args[args.length - 1])) {
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
	}

	if (!coords) {
		if (args.length === 0) {
			return {
				reply: \"No place provided!\",
				cooldown: 2500
			};
		}

		const geoData = await sb.Got({
			url: \"https://maps.googleapis.com/maps/api/geocode/json\",
			searchParams: new sb.URLParams()
				.set(\"key\", sb.Config.get(\"API_GOOGLE_GEOCODING\"))
				.set(\"address\", args.join(\" \"))
				.toString()
		}).json();

		if (!geoData.results[0]) {
			return {
				reply: \"That place was not found! FeelsBadMan\"
			};
		}

		formattedAddress = geoData.results[0].formatted_address;
		coords = geoData.results[0].geometry.location;
	}

	const excluded = [\"currently\", \"minutely\", \"hourly\", \"daily\", \"alerts\"].filter(i => i !== type);
	const key = sb.Config.get(\"API_DARKSKY\");

	const topData = await sb.Got({
		url: `https://api.darksky.net/forecast/${key}/${coords.lat},${coords.lng}`,
		searchParams: new sb.URLParams()
			.set(\"units\", \"si\")
			.set(\"exclude\", excluded.join(\",\"))
			.toString()
	}).json();

	let data = null;
	let message = null;
	if (number === null && type !== \"currently\") {
		message = topData[type].summary;
	}
	else {
		data = (type === \"currently\")
			? topData.currently
			: topData[type].data[number];

		const icon = this.staticData.icons[data.icon];
		const precip = (data.precipProbability === 0)
			? \"No precipitation expected.\"
			: (sb.Utils.round(data.precipProbability * 100) + \"% chance of \" + sb.Utils.round(data.precipIntensity, 2) + \" mm \" + data.precipType + \".\");
		const temp = (type !== \"daily\")
			? (sb.Utils.round(data.temperature, 2) + \"°C.\")
			: (\"Temperatures: \" + sb.Utils.round(data.temperatureMin) + \"°C to \" + sb.Utils.round(data.temperatureMax) + \"°C.\");
		const storm = (type === \"currently\")
			? (typeof data.nearestStormDistance !== \"undefined\")
				? (\"Nearest storm is \" + data.nearestStormDistance + \" km away. \")
				: (\"No storms nearby. \")
			: \"\";
		const feels = (type === \"currently\")
			? `Feels like ${sb.Utils.round(data.apparentTemperature)}°C.`
			: \"\";

		message = sb.Utils.tag.trim `
			${icon ?? data.icon}
			${temp}
			${feels}
			${storm}
			${sb.Utils.round(data.cloudCover * 100)}% cloudy.
			Wind gusts up to ${sb.Utils.round(data.windGust * 3.6)} km/h.
			${sb.Utils.round(data.humidity * 100)}% humidity.
			${precip}
			Air pressure: ~${data.pressure} hPa.
		`;
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
		: formattedAddress;

	return {
		reply: `${place} ${plusTime}: ${message}`
	};
})',
		'(prefix) => [
	\"Checks for current weather, or for hourly/daily/weekly forecast in a given location.\",
	\"If you, or a given user have set their location with the <code>set</code> command, this command supports that.\",
	\"\",

	`<code>${prefix}weather (place)</code>`,
	\"current weather in given location\",
	\"\",

	`<code>${prefix}weather (place) <b>hour+X</b></code>`,
	\"weather forecast in X hour(s) - accepts 1 through 48\",
	\"\",

	`<code>${prefix}weather (place) <b>day+X</b></code>`,
	\"weather forecast in X day(s) - accepts 1 through 7\",
	\"\",

	`<code>${prefix}weather (place) <b>week</b></code>`,
	\"weather summary for the upcoming week\",
	
	\"\",
	\"=\".repeat(20),
	\"\",

	`<code>${prefix}weather</code>`,
	\"If you set your own weather location, show its weather.\",
	\"\",

	`<code>${prefix}weather @User</code>`,
	\"If that user has set their own weather location, show its weather. The <code>@</code> symbol is mandatory.\",
	\"\",	

	`<code>${prefix}weather @User <b>(hour+X/day+X/week)</b></code>`,
	\"Similar to above, shows the user\'s weather, but uses the hour/day/week specifier.\",
]',
		'supinic/supibot-sql'
	)