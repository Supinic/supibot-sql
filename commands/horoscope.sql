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
		237,
		'horoscope',
		NULL,
		'mention,pipe',
		'Checks your horoscope, if you have set your birthday within supibot.',
		30000,
		NULL,
		'({
	zodiac: [
		{ 
			name: \"Aries\",
			start: [3, 21],
			end: [4, 20]
		},
		{ 
			name: \"Taurus\",
			start: [4, 21],
			end: [5, 20]
		},
		{ 
			name: \"Gemini\",
			start: [5, 21],
			end: [6, 21]
		},
		{ 
			name: \"Cancer\",
			start: [6, 22],
			end: [7, 22]
		},
		{ 
			name: \"Leo\",
			start: [7, 23],
			end: [8, 22]
		},
		{ 
			name: \"Virgo\",
			start: [8, 23],
			end: [9, 21]
		},
		{ 
			name: \"Libra\",
			start: [9, 22],
			end: [10, 22]
		},
		{ 
			name: \"Scorpio\",
			start: [10, 23],
			end: [11, 22]
		},
		{ 
			name: \"Sagitarius\",
			start: [11, 23],
			end: [12, 21]
		},
		{ 
			name: \"Capricorn\",
			start: [12, 22],
			end: [1, 20]
		},
		{ 
			name: \"Aquarius\",
			start: [1, 21],
			end: [2, 19]
		},
		{ 
			name: \"Pisces\",
			start: [2, 20],
			end: [3, 20]
		}
	]
})',
		'(async function horoscope (context) {
	if (!context.user.Data.birthday) {
		return {
			success: false,
			reply: `You don\'t have a birthday set up! Use the \"${sb.Command.prefix}set birthday\" command first.`
		};
	}

	let zodiac = null;
	const { day, month } = context.user.Data.birthday;
	for (const { start, end, name } of this.staticData.zodiac) {
		if ((month === start[0] && day >= start[1]) || (month === end[0] && day <= end[1])) {
			zodiac = name;
			break;
		}
	}

	if (zodiac === null) {
		return {
			success: false,
			reply: `No zodiac sign detected...?`
		};
	}

	const { statusCode, body: data } = await sb.Got({
		prefixUrl: \"https://horoscope-api.herokuapp.com\",
		url: \"horoscope/today/\" + zodiac,
		throwHttpErrors: false,
		responseType: \"json\"
	});
	
	if (statusCode !== 200) {
		throw new sb.errors.APIError({
			statusCode,
			apiName: \"HoroscopeHerokuAPI\"
		});
	}

	return {
		reply: `Your horoscope for today: ${data.horoscope}`
	};
})',
		NULL,
		'supinic/supibot-sql'
	)