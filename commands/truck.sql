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
		106,
		'truck',
		NULL,
		'opt-out,pipe,skip-banphrase',
		'Trucks the target user into bed. KKona',
		10000,
		NULL,
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
		NULL
	)