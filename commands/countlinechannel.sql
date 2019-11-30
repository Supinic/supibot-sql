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
		50,
		'countlinechannel',
		'[\"clc\"]',
		'Fetches the amount of chat lines in the current channel.',
		60000,
		0,
		0,
		1,
		0,
		NULL,
		0,
		0,
		0,
		1,
		1,
		0,
		'(async function countLineChannel (context) {
	const channelID = context.channel.ID;
	if (channelID === 7 || channelID === 8) {
		const [{cerebot}, {discord}, {refuge}] = await Promise.all([
			sb.Query.getRecordset(rs => rs.select(\"MAX(ID) AS cerebot\").from(\"chat_line\", \"cerebot\").single()),
			sb.Query.getRecordset(rs => rs.select(\"MAX(ID) AS discord\").from(\"chat_line\", \"discord_150782269382983689\").single()),
			sb.Query.getRecordset(rs => rs.select(\"MAX(ID) AS refuge\").from(\"chat_line\", \"_trump_nonsub_refuge\").single()),
		]);

		const total = cerebot + discord + refuge;
		return {
			reply: `Amount of lines: Cerebot: ${cerebot}; Discord: ${discord}; Refuge: ${refuge}; Total: ${total}`
		};
	}
	else if (channelID === 82) {
		const [{nasabot}, {discord}, {offlineChat}] = await Promise.all([
			sb.Query.getRecordset(rs => rs.select(\"MAX(ID) AS nasabot\").from(\"chat_line\", \"nasabot\").single()),
			sb.Query.getRecordset(rs => rs.select(\"MAX(ID) AS discord\").from(\"chat_line\", \"discord_240523866026278913\").single()),
			sb.Query.getRecordset(rs => rs.select(\"MAX(ID) AS offlineChat\").from(\"chat_line\", \"_core54_1464148741723\").single()),
		]);

		const total = nasabot + discord + offlineChat;
		return {
			reply: `Amount of lines: Nasabot: ${nasabot}; Discord #general: ${discord}; Group chat: ${offlineChat}; Total: ${total}`
		};
	}
	else {
		const channelName = (context.channel.Platform === \"Twitch\")
			? context.channel.Name
			: context.channel.Platform.toLowerCase() + \"_\" + context.channel.Name;

		const {Amount: amount} = (await sb.Query.getRecordset(rs => rs
			.select(\"MAX(ID) AS Amount\")
			.from(\"chat_line\", channelName)
			.single()
		));

		return {
			reply: `Currently logging ${amount} messages in this channel.`
		};
	}
})',
		'No arguments.',
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function countLineChannel (context) {
	const channelID = context.channel.ID;
	if (channelID === 7 || channelID === 8) {
		const [{cerebot}, {discord}, {refuge}] = await Promise.all([
			sb.Query.getRecordset(rs => rs.select(\"MAX(ID) AS cerebot\").from(\"chat_line\", \"cerebot\").single()),
			sb.Query.getRecordset(rs => rs.select(\"MAX(ID) AS discord\").from(\"chat_line\", \"discord_150782269382983689\").single()),
			sb.Query.getRecordset(rs => rs.select(\"MAX(ID) AS refuge\").from(\"chat_line\", \"_trump_nonsub_refuge\").single()),
		]);

		const total = cerebot + discord + refuge;
		return {
			reply: `Amount of lines: Cerebot: ${cerebot}; Discord: ${discord}; Refuge: ${refuge}; Total: ${total}`
		};
	}
	else if (channelID === 82) {
		const [{nasabot}, {discord}, {offlineChat}] = await Promise.all([
			sb.Query.getRecordset(rs => rs.select(\"MAX(ID) AS nasabot\").from(\"chat_line\", \"nasabot\").single()),
			sb.Query.getRecordset(rs => rs.select(\"MAX(ID) AS discord\").from(\"chat_line\", \"discord_240523866026278913\").single()),
			sb.Query.getRecordset(rs => rs.select(\"MAX(ID) AS offlineChat\").from(\"chat_line\", \"_core54_1464148741723\").single()),
		]);

		const total = nasabot + discord + offlineChat;
		return {
			reply: `Amount of lines: Nasabot: ${nasabot}; Discord #general: ${discord}; Group chat: ${offlineChat}; Total: ${total}`
		};
	}
	else {
		const channelName = (context.channel.Platform === \"Twitch\")
			? context.channel.Name
			: context.channel.Platform.toLowerCase() + \"_\" + context.channel.Name;

		const {Amount: amount} = (await sb.Query.getRecordset(rs => rs
			.select(\"MAX(ID) AS Amount\")
			.from(\"chat_line\", channelName)
			.single()
		));

		return {
			reply: `Currently logging ${amount} messages in this channel.`
		};
	}
})'