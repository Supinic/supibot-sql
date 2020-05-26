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
		128,
		'case',
		NULL,
		'archived,ping,pipe',
		'Makes the input lower or uppercase. Only usable in pipe.',
		0,
		NULL,
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
		'supinic/supibot-sql'
	)