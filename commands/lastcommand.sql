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
		206,
		'lastcommand',
		'[\"_\"]',
		'pipe',
		'Posts your last command executed in the current channel. Only goes back up to 1 minute.',
		5000,
		NULL,
		NULL,
		'(async function lastCommand (context) {
	const data = await sb.Query.getRecordset(rs => {
		rs.select(\"Result\")
			.from(\"chat_data\", \"Command_Execution\")
			.where(\"Command <> %n\", this.ID)
			.where(\"User_Alias = %n\", context.user.ID)
			.where(\"Executed > DATE_ADD(NOW(), INTERVAL -1 MINUTE)\")
			.orderBy(\"Executed DESC\")
			.limit(1)
			.single();

		if (context.channel) {
			rs.where(\"Channel = %n\", context.channel.ID)
		}
		else {
			rs.where(\"Channel IS NULL\").where(\"Platform = %n\", context.platform.ID);
		}

		return rs;
	});

	return {
		reply: (data?.Result)
			? String(data.Result)
			: \"No recent command execution found!\"
	};
})',
		NULL
	)