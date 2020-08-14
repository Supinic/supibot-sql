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
	if ((controller?.availableEmotes ?? []).length === 0) {
		return \"Twitch messed up, no emotes available...\";
	}

	return controller.availableEmotes
		.filter(emoteSet => emoteSet.tier === null)
		.flatMap(emoteSet => emoteSet.emotes.map(emote => emote.token));
}',
		'Function',
		'All Twitch global emotes.'
	)