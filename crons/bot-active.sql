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
		3,
		'bot-active',
		'0 */10 * * * *',
		'Pings the bot active API to make sure supibot is being registered as online',
		'(async function cron_botActive () {
	const userData = await sb.User.get(sb.Config.get(\"SELF_ID\"));
	await sb.Got.instances.Supinic({
		method: \"PUT\",
		url: \"bot-program/bot/active\",
		headers: {
			Authorization: `Basic ${userData.ID}:${userData.Data.authKey}`,
		}
	});
})',
		'Bot',
		1
	)