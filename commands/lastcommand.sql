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
		Static_Data,
		Code,
		Examples,
		Dynamic_Description
	)
VALUES
	(
		206,
		'lastcommand',
		'[\"_\"]',
		'Posts your last command executed in the current channel. Only goes back up to 1 minute.',
		5000,
		0,
		0,
		0,
		0,
		NULL,
		0,
		0,
		0,
		0,
		1,
		0,
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
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function lastCommand (context) {
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
})'