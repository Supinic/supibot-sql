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
		18,
		'refresh-twitch-app-access-token',
		'0 0 12 * * *',
		'Refreshes the bot\'s Twitch app access token.',
		'(async function refreshTwitchAppAccessToken () {
	const { access_token: token } = await sb.Got({
		method: \"POST\",
		url: \"https://id.twitch.tv/oauth2/token\",
		responseType: \"json\",
		searchParams: new sb.URLParams()
			.set(\"grant_type\", \"client_credentials\")
			.set(\"client_id\", sb.Config.get(\"TWITCH_CLIENT_ID\"))
			.set(\"client_secret\", sb.Config.get(\"TWITCH_CLIENT_SECRET\"))
			.set(\"scope\", \"\")
			.toString()
	}).json();

	await sb.Config.set(\"TWITCH_APP_ACCESS_TOKEN\", token);
	
	console.log(\"Twitch app access token successfuly updated\");
})',
		'Bot',
		1
	)