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
		6,
		'#bttv',
		'(async function slotsPattern_bttv (context) {
	const data = await sb.Got({
		throwHttpErrors: false,
		url: \"https://api.betterttv.net/2/channels/\" + context.channel.Name
	}).json();

	if (data.status === 404 || !data.emotes || data.emotes.length === 0) {
		return \"Well, yeah, but BTTV is like a 3rd party thing, and I don\'t know...\";
	}

	return data.emotes.map(i => i.code);
})',
		'Function',
		'Rolls from BTTV emotes in the current channel.'
	)