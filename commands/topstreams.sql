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
		Dynamic_Description
	)
VALUES
	(
		157,
		'topstreams',
		NULL,
		'ping,pipe',
		'Checks the top 5 streams on twitch - if you add a game, will look for top 5 streams playing that game. Game must be provided verbatim',
		30000,
		NULL,
		NULL,
		'(async function topStreams (context, ...args) {
	const params = new sb.URLParams(\"%20\").set(\"limit\", 10);
	if (args.length > 0) {
		params.set(\"game\", args.join(\" \"));
	}
	
	const data = await sb.Got.instances.Twitch.Kraken({
		url: \"streams\",
		searchParams: params.toString() 
	}).json();

	if (data._total === 0) {
		return { reply: \"Nobody is playing that game right now!\" };
	}
	else {
		const gameString = (args.length > 0)
			? `are playing ${args.join(\" \")}: `
			: \"are live: \";

		const streamers = data.streams.map(stream => {
			const playing = (gameString)
				? \"\"
				: `${stream.game}`;

			return stream.channel.display_name + \" \" + playing + \" (\" + stream.viewers + \")\";
		});

		return { reply: \"These streamers \" + gameString + streamers.join(\"; \") };
	}
})',
		NULL
	)