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
		196,
		'statistics',
		'[\"stat\", \"stats\"]',
		'ping,pipe',
		'Posts various statistics regarding you, e.g. total afk time.',
		10000,
		NULL,
		'({
	types: [
		{
			names: [\"total-afk\", \"afk\", \"gn\", \"brb\", \"food\", \"shower\", \"lurk\", \"poop\", \"work\", \"study\"],
			description: \"Checks the total time you have been afk for. Each status type is separate, you can use total-afk to check all of them combined.\",
			execute: async (context, type, ...args) => {
				const data = await sb.Query.getRecordset(rs => {
					rs.select(\"SUM(UNIX_TIMESTAMP(Ended) - UNIX_TIMESTAMP(Started)) AS Delta\")
						.from(\"chat_data\", \"AFK\")
						.where(\"User_Alias = %n\", context.user.ID)
						.single();
	
					if (type === \"total-afk\") {
						// Do not add a condition - counts totals
					}
					else if (type === \"afk\") {
						rs.where(\"Status = %s OR Status IS NULL\", type);
					}
					else {
						rs.where(\"Status = %s\", type);
					}
	
					return rs;
				});
	
				const target = (type === \"total-afk\") ? \"(all combined)\" : type;

				if (!data?.Delta) {
					return {
						reply: `You have not been AFK with status \"${target}\" at all.`
					};
				}
				else {
					return {
						reply: `You have been AFK with status \"${target}\" for a total of ${sb.Utils.formatTime(data.Delta)}.`
					};
				}
			}
		}
	]
})',
		'(async function statistics (context, type, ...args) {
	if (!type) {
		return {
			reply: \"No statistic type provided!\",
			cooldown: { length: 1000 }
		}
	}
	
	type = type.toLowerCase();
	const target = this.staticData.types.find(i => i.names.includes(type));

	if (target) {
		return await target.execute(context, type, ...args);
	}
	else {
		return {
			reply: \"Unrecognized statistic type provided!\",
			cooldown: { length: 1000 }
		};
	}
})',
		'async (prefix, values) => {
	const { types } = values.getStaticData();
	const list = types.map(i => {
		const names = i.names.sort().map(j => `<code>${j}</code>`).join(\"<br>\");
		return `${names}<br>${i.description}`;
	}).join(\"\");

	return [
		\"Checks various statistics bound to you, found around supibot\'s data.\",
		\"\",

		`<code>${prefix}stats (type)</code>`,
		\"Statistics based on the type used\",
		\"\",

		\"Types:\",
		`<ul>${list}</ul>`
	];	
}',
		'supinic/supibot-sql'
	)