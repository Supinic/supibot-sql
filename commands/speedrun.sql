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
		12,
		'speedrun',
		'[\"gdq\"]',
		'Posts a Markov chain-generated GDQ speedrun donation message.',
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
		'(async function speedrun () {
/*
	// const url = \"https://taskinoz.com/gdq/api/\";
	const url = \"https://api.ivr.fi/gdq\";
	const data = JSON.parse(await sb.Utils.request(url, {
		headers: {
			\"User-Agent\": sb.Config.get(\"SUPIBOT_USER_AGENT\")
		}
	}));

	return {
		reply: data.response
	};
*/

	const model = await sb.MarkovChain.get(\"gdq-final\");
	return { reply: model.sentences(2) };
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function speedrun () {
/*
	// const url = \"https://taskinoz.com/gdq/api/\";
	const url = \"https://api.ivr.fi/gdq\";
	const data = JSON.parse(await sb.Utils.request(url, {
		headers: {
			\"User-Agent\": sb.Config.get(\"SUPIBOT_USER_AGENT\")
		}
	}));

	return {
		reply: data.response
	};
*/

	const model = await sb.MarkovChain.get(\"gdq-final\");
	return { reply: model.sentences(2) };
})'