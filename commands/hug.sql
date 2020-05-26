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
		70,
		'hug',
		NULL,
		'opt-out,pipe',
		'Hugs target user :)',
		5000,
		NULL,
		NULL,
		'(async function hug (context, target) {
	if (!target) {
		return { reply: \"You didn\'t want to hug anyone, so I\'ll hug you instead 🤗\" };
	}
	else if (target.toLowerCase() === context.platform.Self_Name.toLowerCase()) {
		return { reply: \"Thanks for the hug 🙂 <3\" };
	}
	else {
		return { reply: context.user.Name + \" hugs \" + target + \" 🤗\" };
	}
})',
		NULL,
		'supinic/supibot-sql'
	)