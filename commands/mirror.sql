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
		95,
		'mirror',
		NULL,
		'Toggles the message mirroring status in current channel.',
		5000,
		0,
		0,
		0,
		1,
		NULL,
		0,
		0,
		0,
		1,
		1,
		0,
		NULL,
		'async (extra) => {
	const cytube = sb.Channel.get(\"forsenoffline\");
	const twitch = sb.Channel.get(\"vohvlei\");

	let response = null;
	if (cytube.Mirror && twitch.Mirror) {
		cytube.Mirror = null;
		twitch.Mirror = null;
		response = \"Turned Cytube <=> Twitch mirroring off.\";
	}
	else {
		cytube.Mirror = twitch.ID;
		twitch.Mirror = cytube.ID;
		response = \"Turned Cytube <=> Twitch mirroring on.\";
	}
	
	return { 
		reply: response
	};
}',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async (extra) => {
	const cytube = sb.Channel.get(\"forsenoffline\");
	const twitch = sb.Channel.get(\"vohvlei\");

	let response = null;
	if (cytube.Mirror && twitch.Mirror) {
		cytube.Mirror = null;
		twitch.Mirror = null;
		response = \"Turned Cytube <=> Twitch mirroring off.\";
	}
	else {
		cytube.Mirror = twitch.ID;
		twitch.Mirror = cytube.ID;
		response = \"Turned Cytube <=> Twitch mirroring on.\";
	}
	
	return { 
		reply: response
	};
}'