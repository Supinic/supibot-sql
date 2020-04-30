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
		4,
		'#twitch',
		'() => {
	const { controller } = sb.Platform.get(\"twitch\");

	if (Object.keys(controller.availableEmotes).length === 0) {
		return \"Twitch messed up, no emotes available...\";
	}

	return controller.availableEmotes[0]
		.filter(i => i.id > 15)
		.map(i => i.code);
}',
		'Function',
		'All Twitch global emotes.'
	)