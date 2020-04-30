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
		70,
		'hug',
		NULL,
		NULL,
		'Hugs target user :)',
		5000,
		0,
		0,
		0,
		0,
		NULL,
		0,
		1,
		0,
		0,
		1,
		0,
		0,
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
		'No arguments.',
		NULL
	)