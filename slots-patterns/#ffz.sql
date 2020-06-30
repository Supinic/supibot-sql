INSERT INTO
	`data`.`Slots_Pattern`
	(
		ID,
		Name,
		Pattern,
		Type,
		Notes
	)
VALUES
	(
		7,
		'#ffz',
		'(async function slotsPattern_ffz (context) {
	const { statusCode, body: data } = await sb.Got({
		responseType: \"json\",
		throwHttpErrors: false,
		url: \"https://api.frankerfacez.com/v1/room/\" + context.channel.Name
	});
	
	if (statusCode === 404) {
		return { reply: \"This channel doesn\'t exist within FFZ database!\" };
	}
	else if (!data.sets) {
		return { reply: \"No FFZ emotes found!\" };
	}

	const set = Object.keys(data.sets)[0];
	if (data.sets[set].emoticons.length === 0) {
		return { reply: \"This channel has no FFZ emotes enabled.\" };
	}

	return data.sets[set].emoticons.map(i => i.name);
})',
		'Function',
		'Rolls from FFZ emotes in the current channel.'
	)