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
		Static_Data,
		Code,
		Examples,
		Dynamic_Description
	)
VALUES
	(
		106,
		'truck',
		NULL,
		'Trucks the target user into bed. KKona',
		10000,
		0,
		0,
		1,
		1,
		NULL,
		0,
		0,
		0,
		0,
		1,
		0,
		NULL,
		'async (extra, target) => {
	if (target && target.toLowerCase() === sb.Config.get(\"SELF\")) {
		return { reply: \"KKonaW I\'M DRIVING THE TRUCK KKonaW GET OUT OF THE WAY KKonaW\" };
	}
	else if (target && target.toLowerCase() !== extra.user.Name) {
		return { reply: `You truck ${target} into bed with the power of a V8 engine KKonaW 👉🛏🚚` };
	}
	else {
		return { reply: \"The truck ran you over KKoooona\" };
	}
}',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async (extra, target) => {
	if (target && target.toLowerCase() === sb.Config.get(\"SELF\")) {
		return { reply: \"KKonaW I\'M DRIVING THE TRUCK KKonaW GET OUT OF THE WAY KKonaW\" };
	}
	else if (target && target.toLowerCase() !== extra.user.Name) {
		return { reply: `You truck ${target} into bed with the power of a V8 engine KKonaW 👉🛏🚚` };
	}
	else {
		return { reply: \"The truck ran you over KKoooona\" };
	}
}'