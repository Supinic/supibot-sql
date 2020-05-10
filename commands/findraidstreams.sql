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
		150,
		'findraidstreams',
		'[\"frs\"]',
		'pipe,system,whitelist',
		'Iterates over eligible Twitch channel, finds online streams and posts a summary to Pastebin. Used to find a good raid after a stream is finished.',
		0,
		NULL,
		'({
	viewerThreshold: 100,
	ignoredChannels: [ 42 ]
})',
		'(async function findRaidStreams () {
	const raidable = sb.Channel.data
		.filter(i => (
			i.sessionData?.live
			&& !this.staticData.ignoredChannels.includes(i.ID)
		))
		.map(channel => {
			const { stream } = channel.sessionData;
			return {
				name: channel.Name,
				game: stream.game,
				status: stream.status,
				viewers: stream.viewers,
				online: sb.Utils.timeDelta(stream.since, true)
			};
		})
		.filter(i => i.viewers < this.staticData.viewerThreshold)
		.sort((a, b) => b.viewers - a.viewers);

	return {
		reply: await sb.Pastebin.post(JSON.stringify(raidable, null, 4), {
			name: \"Raid targets \" + new sb.Date().format(\"Y-m-d H:i:s\"),
			format: \"json\"
		})
	};
})',
		NULL
	)