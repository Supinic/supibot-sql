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
		5,
		'#sub',
		'() => {
	const { controller } = sb.Platform.get(\"twitch\");

	if (Object.keys(controller.availableEmotes).length === 0) {
		return \"Twitch messed up, no emotes available...\";
	}

	return Object.entries(controller.availableEmotes)
		.filter(([key]) => Number(key) > 0 && Number(key) < 3e8)
		.map(([key, array]) => array.map(emote => emote.code))
		.flat();
}',
		'Function',
		'Rolls random emotes from supibot\'s current subscriber emote list.'
	)