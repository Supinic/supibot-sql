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
		164,
		'OMEGALUL',
		NULL,
		'archived,ping,pipe',
		'Replaces all capital \"O\"\'s by \"OMEGALUL\"',
		10000,
		NULL,
		NULL,
		'async (extra, ...args) => {
	return {
		reply: \"Command is deprecated. Use $texttransform OMEGALUL (or $tt OMEGALUL for short)\"
	};

	if (args.length === 0) {
		return { reply: \"Pepega\" };
	}

	return { 
		reply: args.join(\" \").replace(/[oOｏＯоО]/g, \" OMEGALUL \")
	};
}',
		NULL,
		'supinic/supibot-sql'
	)