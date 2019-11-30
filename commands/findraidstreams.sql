INSERT INTO
	`chat_data`.`Command`
	(
		ID,
		Name,
		Aliases,
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
		Archived,
		Code,
		Examples,
		Dynamic_Description
	)
VALUES
	(
		150,
		'findraidstreams',
		'[\"frs\"]',
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
		'async () => {
	const excludedChannels = sb.Config.get(\"TWITCH_RAID_EXCLUDED_CHANNELS\");
	const eligibleChannels = sb.Channel.data.filter(i => (
		(i.Platform === \"Twitch\")
		&& (i.Mode !== \"Read\" && i.Mode !== \"Inactive\")
		&& (i.Specific_ID !== null)
		&& (!excludedChannels.includes(i.ID))
	)).map(i => \"user_login=\" + i.Name);

	const data = JSON.parse(await sb.Utils.request({
		type: \"GET\",
		url: \"https://api.twitch.tv/helix/streams/?\" + eligibleChannels.join(\"&\"),
		headers: {
			\"Client-ID\": sb.Config.get(\"TWITCH_CLIENT_ID\"),
		}
	})).data;
	
	const results = [];
	if (data.length === 0) {
		results.push(\"No raidable streams are currently live.\");
	}
	else {
		const gameIDs = data.map(i => \"id=\" + i.game_id);
		const gameData = JSON.parse(await sb.Utils.request({
			type: \"GET\",
			url: \"https://api.twitch.tv/helix/games/?\" + gameIDs.join(\"&\"),
			headers: {
				\"Client-ID\": sb.Config.get(\"TWITCH_CLIENT_ID\"),
			}
		})).data;		
		
		for (const stream of data) {
			results.push({
				name: stream.user_name,
				title: stream.title,
				// game: gameData.find(i => i.id === stream.game_id).name,
				online: sb.Utils.timeDelta(new sb.Date(stream.started_at)),
				viewers: stream.viewer_count
			});
		}
	}
	
	return { reply: await sb.Pastebin.post(JSON.stringify(results, null, 4)) };
}',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async () => {
	const excludedChannels = sb.Config.get(\"TWITCH_RAID_EXCLUDED_CHANNELS\");
	const eligibleChannels = sb.Channel.data.filter(i => (
		(i.Platform === \"Twitch\")
		&& (i.Mode !== \"Read\" && i.Mode !== \"Inactive\")
		&& (i.Specific_ID !== null)
		&& (!excludedChannels.includes(i.ID))
	)).map(i => \"user_login=\" + i.Name);

	const data = JSON.parse(await sb.Utils.request({
		type: \"GET\",
		url: \"https://api.twitch.tv/helix/streams/?\" + eligibleChannels.join(\"&\"),
		headers: {
			\"Client-ID\": sb.Config.get(\"TWITCH_CLIENT_ID\"),
		}
	})).data;
	
	const results = [];
	if (data.length === 0) {
		results.push(\"No raidable streams are currently live.\");
	}
	else {
		const gameIDs = data.map(i => \"id=\" + i.game_id);
		const gameData = JSON.parse(await sb.Utils.request({
			type: \"GET\",
			url: \"https://api.twitch.tv/helix/games/?\" + gameIDs.join(\"&\"),
			headers: {
				\"Client-ID\": sb.Config.get(\"TWITCH_CLIENT_ID\"),
			}
		})).data;		
		
		for (const stream of data) {
			results.push({
				name: stream.user_name,
				title: stream.title,
				// game: gameData.find(i => i.id === stream.game_id).name,
				online: sb.Utils.timeDelta(new sb.Date(stream.started_at)),
				viewers: stream.viewer_count
			});
		}
	}
	
	return { reply: await sb.Pastebin.post(JSON.stringify(results, null, 4)) };
}'