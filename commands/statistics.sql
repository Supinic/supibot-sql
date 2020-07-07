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
		},
		{
			names: [\"sr\"],
			description: \"Checks various sr statistics on supinic\'s channel.\",
			execute: async function execute (context, type, ...args) {
				let branch = null;
				let targetUser = null;
				let videoID = null;

				if (args.length === 0) {
					branch = \"user\";
					targetUser = context.user;
				}
				else {
					const [target] = args;
					const userCheck = await sb.User.get(target);
					if (userCheck) {
						branch = \"user\";
						targetUser = userCheck;
					}
					else {
						branch = \"video\";
						videoID = target;
					}
				}

				if (branch === \"user\") {
					return await this.helpers.fetchUserStats(targetUser);
				}
				else if (branch === \"video\") {
					return await this.helpers.fetchVideoStats(videoID);
				}
			},

			helpers: {
				fetchUserStats: async function (targetUser) {
					const requests = await sb.Query.getRecordset(rs => rs
						.select(\"Link\", \"Length\", \"Start_Time\", \"End_Time\")
						.from(\"chat_data\", \"Song_Request\")
						.where(\"User_Alias = %n\", targetUser.ID)
					);

					if (requests.length === 0) {
						return {
							reply: `No requested videos found.`
						};
					}

					const counter = {};
					let totalLength = 0;
					let mostRequested = null;
					let currentMax = 0;

					for (const video of requests) {
						if (typeof counter[video.Link] === \"undefined\") {
							counter[video.Link] = 0;
						}

						counter[video.Link]++;
						totalLength += (video.End_Time ?? video.Length) - (video.Start_Time ?? 0);
						if (currentMax < counter[video.Link]) {
							mostRequested = video.Link;
							currentMax = counter[video.Link];
						}
					}

					const total = sb.Utils.timeDelta(sb.Date.now() + totalLength * 1000, true);
					return {
						reply: sb.Utils.tag.trim `
							Videos requested: ${requests.length}, for a total runtime of ${total}.
							The most requested video is ${mostRequested} - queued ${currentMax} times.
						`
					};
				},
				fetchVideoStats: async function (videoID) {
					if (sb.Utils.linkParser.autoRecognize(videoID)) {
						videoID = sb.Utils.linkParser.parseLink(videoID);
					}

					const requests = await sb.Query.getRecordset(rs => rs
						.select(\"Added\")
						.from(\"chat_data\", \"Song_Request\")
						.where(\"Link = %s\", videoID)
						.orderBy(\"ID DESC\")
					);

					if (requests.length === 0) {
						return {
							reply: `No videos found by given ID.`
						};
					}

					const lastDelta = sb.Utils.timeDelta(requests[0].Added);
					return {
						reply: sb.Utils.tag.trim `
							This video has been requested ${requests.length} times.
							It was last requested ${lastDelta}.
						`
					};
				},
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