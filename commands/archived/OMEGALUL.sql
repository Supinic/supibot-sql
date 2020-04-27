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
		164,
		'OMEGALUL',
		NULL,
		NULL,
		'Replaces all capital \"O\"\'s by \"OMEGALUL\"',
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
		1,
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
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async (extra, ...args) => {
	return {
		reply: \"Command is deprecated. Use $texttransform OMEGALUL (or $tt OMEGALUL for short)\"
	};

	if (args.length === 0) {
		return { reply: \"Pepega\" };
	}

	return { 
		reply: args.join(\" \").replace(/[oOｏＯоО]/g, \" OMEGALUL \")
	};
}'