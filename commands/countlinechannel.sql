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
		Dynamic_Description,
		Source
	)
VALUES
	(
		50,
		'countlinechannel',
		'[\"clc\"]',
		'mention,pipe,skip-banphrase',
		'Fetches the amount of chat lines in the current channel.',
		60000,
		NULL,
		NULL,
		'(async function countLineChannel (context) {
	if (!context.channel) {
		return {
			reply: \"Command not available in private messages!\"
		};
	}

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
		const channelName = context.channel.getDatabaseName();
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
		NULL,
		'supinic/supibot-sql'
	)