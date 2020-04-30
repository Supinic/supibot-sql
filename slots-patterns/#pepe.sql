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
		8,
		'#pepe',
		'(async function slotsPattern_pepe (context) {
	const fullEmotesList = (await Promise.all([
		(async () => {
			const raw = await sb.Got(\"https://api.betterttv.net/2/channels/\" + context.channel.Name).json();
			if (raw.status === 404 || raw.emotes.length === 0) {
				return [];
			}

			return raw.emotes.map(i => i.code);
		})(),
		(async () => {
			const raw = await sb.Got(\"https://api.frankerfacez.com/v1/room/\" + context.channel.Name).json();
			const set = Object.keys(raw.sets)[0];
			if (raw.sets[set].emoticons.length === 0) {
				return [];
			}

			return raw.sets[set].emoticons.map(i => i.name);
		})()
	])).flat();

	const filtered = fullEmotesList.filter(i => i.toLowerCase().includes(\"pepe\"));
	return (filtered.length >= 3)
		? filtered
		: \"Not enough pepe- emotes are active in this channel supiniL\";
})',
		'Function',
		'Rolls from all emotes in the current channel that contain the string \"pepe\"'
	)