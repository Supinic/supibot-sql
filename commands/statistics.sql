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
		196,
		'statistics',
		'[\"stat\", \"stats\"]',
		'ping,pipe',
		'Posts various statistics regarding you, e.g. total afk time.',
		10000,
		NULL,
		NULL,
		'(async function statistics (context, type) {
	if (!type) {
		return {
			reply: \"No statistic type provided!\",
			cooldown: { length: 1000 }
		}
	}
	
	type = type.toLowerCase();

	switch (type) {
		case \"afk\":
		case \"gn\":
		case \"brb\":
		case \"food\":
		case \"shower\":
		case \"lurk\":
		case \"poop\":
		case \"work\": 
		case \"study\":  {
			const data = await sb.Query.getRecordset(rs => {
				rs.select(\"SUM(UNIX_TIMESTAMP(Ended) - UNIX_TIMESTAMP(Started)) AS Delta\")
					.from(\"chat_data\", \"AFK\")
					.where(\"User_Alias = %n\", context.user.ID)
					.single();
				
				if (type === \"afk\") {
					rs.where(\"Status = %s OR Status IS NULL\", type);
				}			
				else {
					rs.where(\"Status = %s\", type);
				}
			
				return rs;
			});
		
			if (!data) {
				return {
					reply: `You have not been AFK with status \"${type}\" at all.`
				};
			}
			else {
				return {
					reply: `You have been AFK with status \"${type}\" for a total of ${sb.Utils.formatTime(data.Delta)}.`
				};
			}
		}

		default: return {
			reply: \"Unrecognized statistic type provided!\",
			cooldown: { length: 1000 }
		}
	}
})',
		NULL
	)