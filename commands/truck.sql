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
		106,
		'truck',
		NULL,
		'opt-out,pipe,skip-banphrase',
		'Trucks the target user into bed. KKona',
		10000,
		NULL,
		NULL,
		'(async function truck (context, target) {
	if (target && target.startsWith(\"@\")) {
		target = target.slice(1);
	}

	if (target?.toLowerCase() === context.platform.Self_Name) {
		return { 
			reply: \"KKonaW I\'M DRIVING THE TRUCK KKonaW GET OUT OF THE WAY KKonaW\"
		};
	}
	else if (target && target.toLowerCase() !== context.user.Name) {
		return {
			reply: `You truck ${target} into bed with the power of a V8 engine KKonaW 👉🛏🚚`
		};
	}
	else {
		return { 
			reply: \"The truck ran you over KKoooona\"
		};
	}
})',
		NULL,
		'supinic/supibot-sql'
	)