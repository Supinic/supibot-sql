INSERT INTO
	`chat_data`.`Cron`
	(
		ID,
		Name,
		Expression,
		Description,
		Code,
		Type,
		Active
	)
VALUES
	(
		10,
		'fetch-horoscope-cookie',
		'0 0 10/22 * * *',
		'Automatically yoinks a cookie from horoscope.com and adds an extract of it into the database.',
		'(async function cron_fetchHoroscopeCookie () {
	const zodiac = [\"aquarius\", \"pisces\", \"aries\", \"taurus\", \"gemini\", \"cancer\", \"leo\", \"virgo\", \"libra\", \"scorpio\", \"sagittarius\", \"capricorn\"];
	const regex = new RegExp(`,\\\\s*(${zodiac.join(\"|\")})`, \"gi\");

	const sign = sb.Utils.random(1, 12);
	const html = await sb.Got({
		prefixUrl: \"https://horoscope.com/us/horoscopes/general/\",
		url: \"horoscope-general-daily-today.aspx\",
		searchParams: `sign=${sign}`
	}).text();

	const $ = sb.Utils.cheerio(html);
	const text = $(\".main-horoscope p\").first().text();
	const cookie = text.slice(text.indexOf(\"-\") + 1)
		.split(/(?:([.?!] ))/)
		.slice(0, 4)
		.join(\"\")
		.trim()
		.replace(regex, \"\");

	const row = await sb.Query.getRow(\"data\", \"Fortune_Cookie\");
	row.setValues({
		Text: cookie,
		Submitter: sb.Config.get(\"SELF_ID\") + \".\",
		Notes: \"Automatically fetched from horoscope.com on \" + new sb.Date().format(\"Y-m-d H:i\")
	});

	const { insertId } = await row.save();

	const channelData = sb.Channel.get(\"supinic\", \"twitch\");
	await channelData.send(`Fetched a new cookie! ID ${id} saved to the database.`);
})',
		'Bot',
		1
	)