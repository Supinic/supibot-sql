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
		27,
		'%',
		NULL,
		'Rolls a random percentage between 0 and 100%',
		5000,
		0,
		0,
		1,
		0,
		NULL,
		0,
		0,
		0,
		1,
		1,
		0,
		'(async function _percent () {
	const number = (sb.Utils.random(0, 10000) / 100);
	return { reply: number + \"%\" };
})',
		'No arguments.

$%',
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function _percent () {
	const number = (sb.Utils.random(0, 10000) / 100);
	return { reply: number + \"%\" };
})'