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
		128,
		'case',
		NULL,
		NULL,
		'Makes the input lower or uppercase. Only usable in pipe.',
		0,
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
		1,
		NULL,
		'(async function _case (context, type, ...args) {
	return {
		reply: \"Command deprecated. Use $texttransform uppercase/lowercase (or just $tt uc/lc for short)\"
	};

	if (!context.append.pipe) {
		return { reply: \"Command is not available outside of the pipe command!\" };
	}
	else if (!type) {
		return { success: false, reason: \"no-type\" };
	}

	const message = args.join(\" \");
	switch (type.toLowerCase()) {
		case \"upper\": return { reply: message.toUpperCase() };

		case \"lower\": return { reply: message.toLowerCase() };

		case \"camel\": return { reply: message.replace(/\\s+(\\w)/g, (total, char) => char.toUpperCase()) };
	
		default: return { success: false, reason: \"no-type\" };
	}
})',
		NULL,
		NULL
	)