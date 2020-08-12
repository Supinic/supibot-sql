INSERT INTO
	`chat_data`.`Chat_Module`
	(
		ID,
		Name,
		Events,
		Description,
		Code
	)
VALUES
	(
		5,
		'offline-only-mode',
		'[\"online\", \"offline\"]',
		'Makes Supibot go into Read-only mode when the channel is online. Reverts back when the channel goes offline.',
		'(async function (context) {
	if (context.event === \"online\" && context.channel.Mode !== \"Read\") {
		context.channel.Mode = \"Read\";
	}	
	else if (context.event === \"offline\" && context.channel.Mode === \"Read\") {
		context.channel.Mode = \"Write\";
	}
})'
	)