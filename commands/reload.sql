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
		21,
		'reload',
		NULL,
		'pipe,skip-banphrase,system,whitelist',
		'Reloads a database definition or hotloads an updated script',
		0,
		NULL,
		NULL,
		'(async function reload (context, target, ...rest) {
	switch (target) {
		case \"afks\": await sb.AwayFromKeyboard.reloadData(); break;

		case \"bans\":
		case \"filters\": await sb.Filter.reloadData(); break;

		case \"banphrases\": await sb.Banphrase.reloadData(); break;

		case \"channels\": await sb.Channel.reloadData(); break;

		case \"commands\": await sb.Command.reloadData(); break;
		case \"command\": {
			try {
				await sb.Command.reloadSpecific(target, ...rest);
			}
			catch {
				return {
					success: false,
					reply: \"No valid commands provided!\"
				};
			}

			break;
		}

		case \"config\": await sb.Config.reloadData(); break;

		case \"cron\": await sb.Cron.reloadData(); break;

		case \"extranews\": await sb.ExtraNews.reloadData(); break;

		case \"got\": await sb.Got.reloadData(); break;

		case \"reminders\": await sb.Reminder.reloadData(); break;

		case \"users\": await sb.User.reloadData(); break;

		default: return { reply: \"Unrecognized module!\" };
	}

	sb.Runtime.incrementScriptHotloaded();
	sb.Master.reloaded = new sb.Date();

	return {
		reply: \"Reloaded successfully.\"
	};
})',
		NULL
	)