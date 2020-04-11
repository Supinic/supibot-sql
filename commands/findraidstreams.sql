INSERT INTO
	`chat_data`.`Command`
	(
		ID,
		Name,
		Aliases,
		Flags,
		Description,
		Cooldown,
		Rollbackable,
		System,
		Skip_Banphrases,
		Whitelisted,
		Whitelist_Response,
		Read_Only,
		Opt_Outable,
		Blockable,
		Ping,
		Pipeable,
		Owner_Override,
		Archived,
		Static_Data,
		Code,
		Examples,
		Dynamic_Description
	)
VALUES
	(
		150,
		'findraidstreams',
		'[\"frs\"]',
		NULL,
		'Iterates over eligible Twitch channel, finds online streams and posts a summary to Pastebin. Used to find a good raid after a stream is finished.',
		0,
		0,
		1,
		0,
		1,
		NULL,
		0,
		0,
		0,
		0,
		1,
		0,
		0,
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
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function findRaidStreams () {
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
})'