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
	if ((controller?.availableEmotes ?? []).length === 0) {
		return \"Twitch messed up, no emotes available...\";
	}

	return controller.availableEmotes
		.filter(emoteSet => [\"1\", \"2\", \"3\"].includes(emoteSet.tier))
		.flatMap(emoteSet => emoteSet.emotes.map(emote => emote.token));
}',
		'Function',
		'Rolls random emotes from supibot\'s current subscriber emote list.'
	)