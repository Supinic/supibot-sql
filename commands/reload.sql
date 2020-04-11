INSERT INTO
	`chat_data`.`Command`
	(
		ID,
		Name,
		Aliases,
		Flags,
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
		Owner_Override,
		Archived,
		Static_Data,
		Code,
		Examples,
		Dynamic_Description
	)
VALUES
	(
		21,
		'reload',
		NULL,
		NULL,
		'Reloads a database definition or hotloads an updated script',
		0,
		0,
		1,
		1,
		1,
		NULL,
		0,
		0,
		0,
		0,
		1,
		0,
		0,
		NULL,
		'(async function reload (context, target, ...rest) {
	const modulePath = \"../../supinic-globals\";

	switch (target) {
		case \"AFK\":
		case \"AwayFromKeyboard\": await sb.AwayFromKeyboard.reloadModule(); break;
		case \"afks\": await sb.AwayFromKeyboard.reloadData(); break;

		case \"Ban\":
		case \"Filter\":
			sb.Filter = null;
			delete require.cache[require.resolve(modulePath + \"/classes/filter.js\")];
			sb.Filter = require(modulePath + \"/classes/filter.js\");
			await sb.Filter.reloadData();
			break;
		case \"bans\":
		case \"filters\": await sb.Filter.reloadData(); break;

		case \"Banphrase\": await sb.Banphrase.reloadModule(); break;
		case \"banphrases\": await sb.Banphrase.reloadData(); break;

		case \"Channel\": await sb.Channel.reloadModule(); break;
		case \"channels\": await sb.Channel.reloadData(); break;

		case \"Command\":
			sb.Command = null;
			delete require.cache[require.resolve(modulePath + \"/classes/command.js\")];
			sb.Command = require(modulePath + \"/classes/command.js\");
			await sb.Command.initialize();
			break;
		case \"commands\": await sb.Command.reloadData(); break;
		case \"command\": await sb.Command.reloadSpecific(target, ...rest); break;

		case \"Config\":
		case \"config\": await sb.Config.reloadData(); break;

		case \"Cron\":
		case \"cron\": await sb.Cron.reloadData(); break;

		case \"Date\":
			sb.Date = null;
			delete require.cache[require.resolve(modulePath + \"/objects/date.js\")];
			sb.Date = require(modulePath + \"/objects/date.js\");
			break;

		case \"extranews\": await sb.ExtraNews.reloadData(); break;

		case \"got\": await sb.Got.reloadData(); break;

		case \"MarkovChain\":
			sb.MarkovChain = null;
			delete require.cache[require.resolve(modulePath + \"/classes/markov-chain.js\")];
			sb.MarkovChain = require(modulePath + \"/classes/markov-chain.js\");
			sb.MarkovChain.initialize();
			break;

		case \"Reminder\": await sb.Reminder.reloadModule(); break;
		case \"reminders\": await sb.Reminder.reloadData(); break;

		case \"User\": await sb.User.reloadModule(); break;
		case \"users\": await sb.User.reloadData(); break;

		default: return { reply: \"Unrecognized module!\" };
	}

	sb.Runtime.incrementScriptHotloaded();
	sb.Master.reloaded = new sb.Date();

	return {
		reply: \"Reloaded successfully.\"
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function reload (context, target, ...rest) {
	const modulePath = \"../../supinic-globals\";

	switch (target) {
		case \"AFK\":
		case \"AwayFromKeyboard\": await sb.AwayFromKeyboard.reloadModule(); break;
		case \"afks\": await sb.AwayFromKeyboard.reloadData(); break;

		case \"Ban\":
		case \"Filter\":
			sb.Filter = null;
			delete require.cache[require.resolve(modulePath + \"/classes/filter.js\")];
			sb.Filter = require(modulePath + \"/classes/filter.js\");
			await sb.Filter.reloadData();
			break;
		case \"bans\":
		case \"filters\": await sb.Filter.reloadData(); break;

		case \"Banphrase\": await sb.Banphrase.reloadModule(); break;
		case \"banphrases\": await sb.Banphrase.reloadData(); break;

		case \"Channel\": await sb.Channel.reloadModule(); break;
		case \"channels\": await sb.Channel.reloadData(); break;

		case \"Command\":
			sb.Command = null;
			delete require.cache[require.resolve(modulePath + \"/classes/command.js\")];
			sb.Command = require(modulePath + \"/classes/command.js\");
			await sb.Command.initialize();
			break;
		case \"commands\": await sb.Command.reloadData(); break;
		case \"command\": await sb.Command.reloadSpecific(target, ...rest); break;

		case \"Config\":
		case \"config\": await sb.Config.reloadData(); break;

		case \"Cron\":
		case \"cron\": await sb.Cron.reloadData(); break;

		case \"Date\":
			sb.Date = null;
			delete require.cache[require.resolve(modulePath + \"/objects/date.js\")];
			sb.Date = require(modulePath + \"/objects/date.js\");
			break;

		case \"extranews\": await sb.ExtraNews.reloadData(); break;

		case \"got\": await sb.Got.reloadData(); break;

		case \"MarkovChain\":
			sb.MarkovChain = null;
			delete require.cache[require.resolve(modulePath + \"/classes/markov-chain.js\")];
			sb.MarkovChain = require(modulePath + \"/classes/markov-chain.js\");
			sb.MarkovChain.initialize();
			break;

		case \"Reminder\": await sb.Reminder.reloadModule(); break;
		case \"reminders\": await sb.Reminder.reloadData(); break;

		case \"User\": await sb.User.reloadModule(); break;
		case \"users\": await sb.User.reloadData(); break;

		default: return { reply: \"Unrecognized module!\" };
	}

	sb.Runtime.incrementScriptHotloaded();
	sb.Master.reloaded = new sb.Date();

	return {
		reply: \"Reloaded successfully.\"
	};
})'