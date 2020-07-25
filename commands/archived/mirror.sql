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
		95,
		'mirror',
		NULL,
		'archived,mention,pipe,whitelist',
		'Toggles the message mirroring status in current channel.',
		5000,
		NULL,
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
		'supinic/supibot-sql'
	)