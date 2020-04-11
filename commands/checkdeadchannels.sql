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
		145,
		'checkdeadchannels',
		'[\"cdc\"]',
		NULL,
		'Iterates over active channels, takes the last posted message in each, and prints the dates + messages into a Pastebin paste. This is useful to determine if and which channels could potentially be removed from the bot because of prolonged inactivity.',
		0,
		0,
		1,
		1,
		1,
		NULL,
		0,
		0,
		0,
		0,
		1,
		0,
		0,
		NULL,
		'async () => {
	const promises = [];
	const regex = /^[^:]+$/;
	const channels = sb.Channel.data.filter(channel => (
		channel.Platform.Name === \"twitch\" && regex.test(channel.Name) && channel.Mode !== \"Inactive\"
	));

	for (const channel of channels) {
		const dbName = channel.getDatabaseName();
		promises.push((async () => {;
			const data = await sb.Query.getRecordset(rs => rs
				.select(\"User_Alias.Name AS Name\", \"Posted\", \"Text\")
				.from(\"chat_line\", dbName)
				.join(\"chat_data\", \"User_Alias\")
				.orderBy(dbName + \".ID DESC\")
				.limit(1)
				.single()
			);

			if (!data) {
				return {
					Posted: new Date(0),
					stuff: \"Nothing?\",
					channel: channel.Name
				};
			}

			data.Channel = channel.Name;
			return data;
		})());
	}

	const results = (await Promise.all(promises)).filter(Boolean).sort((a, b) => a.Posted - b.Posted);
	return { 
		reply: await sb.Pastebin.post(JSON.stringify(results, null, 4))
	};
}',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async () => {
	const promises = [];
	const regex = /^[^:]+$/;
	const channels = sb.Channel.data.filter(channel => (
		channel.Platform.Name === \"twitch\" && regex.test(channel.Name) && channel.Mode !== \"Inactive\"
	));

	for (const channel of channels) {
		const dbName = channel.getDatabaseName();
		promises.push((async () => {;
			const data = await sb.Query.getRecordset(rs => rs
				.select(\"User_Alias.Name AS Name\", \"Posted\", \"Text\")
				.from(\"chat_line\", dbName)
				.join(\"chat_data\", \"User_Alias\")
				.orderBy(dbName + \".ID DESC\")
				.limit(1)
				.single()
			);

			if (!data) {
				return {
					Posted: new Date(0),
					stuff: \"Nothing?\",
					channel: channel.Name
				};
			}

			data.Channel = channel.Name;
			return data;
		})());
	}

	const results = (await Promise.all(promises)).filter(Boolean).sort((a, b) => a.Posted - b.Posted);
	return { 
		reply: await sb.Pastebin.post(JSON.stringify(results, null, 4))
	};
}'