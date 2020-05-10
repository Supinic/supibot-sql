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
		53,
		'check',
		NULL,
		'ping,pipe',
		'Checks certain variables you have set. Currently supports \"reminder\", \"cookie\".',
		10000,
		NULL,
		NULL,
		'(async function check (context, type, identifier) {
	if (!type) {
		return {
			reply: \"No type provided! Please see the help of this command for more info.\"
		};
	}

	switch (type.toLowerCase()) {
		case \"afk\": {
			if (!identifier) {
				return { reply: \"Using my advanced quantum processing, I have concluded that you are not AFK! (no user provided)\" };
			}

			const targetUser = await sb.User.get(identifier, true);
			if (!targetUser) {
				return { reply: \"That user was not found!\" };
			}
			else if (targetUser.ID === sb.Config.get(\"SELF_ID\")) {
				return { reply: \"MrDestructoid I\'m never AFK MrDestructoid I\'m always watching MrDestructoid\" };
			}

			const afkData = await sb.Query.getRecordset(rs => rs
				.select(\"Text\", \"Started\", \"Silent\", \"Status\")
				.from(\"chat_data\", \"AFK\")
				.where(\"User_Alias = %n\", targetUser.ID)
				.where(\"Active = %b\", true)
				.single()
			);

			if (!afkData) {
				return {
					reply: \"That user is not AFK.\"
				};
			}
			else {
				const type = (afkData.Status === \"afk\") ? \"\" : ` (${afkData.Status})`;
				const foreign = (afkData.Silent) ? \"(set via different bot)\" : \"\";
				const delta = sb.Utils.timeDelta(afkData.Started);
				return {
					reply: `That user is currently AFK${type}: ${afkData.Text || \"(no message)\"} ${foreign} (since ${delta})`
				};
			}
		}

		case \"cookie\": {
			let targetUser = context.user;
			if (identifier) {
				targetUser = await sb.User.get(identifier, true);
			}

			if (!targetUser) {
				return {
					reply: \"Provided user does not exist!\"
				};
			}

			const pronoun = (context.user.ID === targetUser.ID) ? \"You\" : \"They\";
			const check = await sb.Query.getRecordset(rs => rs
				.select(\"Cookie_Today\", \"Cookie_Is_Gifted\")
				.from(\"chat_data\", \"Extra_User_Data\")
				.where(\"User_Alias = %n\", targetUser.ID)
				.single()
			);

			let string = null;
			if (!check) {
				string = pronoun + \" have never eaten a cookie before.\";
			}
			else if (check.Cookie_Today) {
				string = (check.Cookie_Is_Gifted)
					? pronoun + \" have already eaten the daily and gifted cookie today.\"
					: pronoun + \" have already eaten/gifted the daily cookie today.\";

				const date = new sb.Date().addDays(1);
				date.setUTCHours(0, 0, 0, 0);

				string += ` The next cookie will be available in ${sb.Utils.timeDelta(date)}.`;
			}
			else {
				string = (check.Cookie_Is_Gifted)
					? pronoun + \" have a gifted cookie waiting.\"
					: pronoun + \" have an unused cookie waiting.\";
			}

			return {
				reply: string
			};
		}

		case \"error\": {
			if (!context.user.Data.inspectErrorStacks) {
				return {
					reply: \"Sorry, you can\'t inspect error stacks!\"
				};
			}

			if (!Number(identifier)) {
				return {
					reply: \"Invalid ID provided!\"
				};
			}

			const row = await sb.Query.getRow(\"chat_data\", \"Error\");
			try {
				await row.load(Number(identifier));
			}
			catch {
				return {
					reply: \"No such error exists!\"
				};
			}

			const { ID, Stack: stack } = row.values;

			if (!this.data.cache) {
				this.data.cache = {};
			}
			if (!this.data.cache[ID] || this.data.cache[ID].expiration < sb.Date.now()) {
				this.data.cache[ID] = {
					createdAt: sb.Date.now(),
					expiration: new sb.Date().addHours(1).valueOf(),
					link: await sb.Pastebin.post(stack, {
						name: \"Stack of Supibot error ID \" + ID,
						expiration: \"1H\"
					})
				};
			}

			if (context.channel) {
				sb.Master.send(\"The error stack Pastebin link has been whispered to you 💻\", context.channel.ID);
			}

			return {
				reply: this.data.cache[ID].link,
				replyWithPrivateMessage: true
			}
		}

		case \"notify\": case \"notification\":
		case \"notifications\": case \"reminder\": case \"reminders\": {
			const ID = Number(identifier);
			if (!ID) {
				return {
					reply: \"Check all of your reminders here (requires login): https://supinic.com/bot/reminder/list\"
				};
			}

			const reminder = await sb.Query.getRecordset(rs => rs
				.select(\"ID\", \"User_From\", \"User_To\", \"Text\", \"Active\", \"Schedule\")
				.from(\"chat_data\", \"Reminder\")
				.where(\"ID = %n\", ID)
				.single()
			);

			if (!reminder) {
				return {
					reply: \"That reminder doesn\'t exist!\"
				};
			}
			else if (reminder.User_From !== context.user.ID && reminder.User_To !== context.user.ID) {
				return {
					reply: \"That reminder was not created by you or for you. Stop peeking!\"
				};
			}

			const alreadyFired = (reminder.Active) ? \"\" : \"(inactive)\";
			const reminderUser = (context.user.ID === reminder.User_From)
				? await sb.User.get(reminder.User_To, true)
				: await sb.User.get(reminder.User_From, true);

			const [owner, target] = (context.user.ID === reminder.User_From)
				? [\"Your reminder\", \"to \" + reminderUser.Name]
				: [\"Reminder\", \"by \" + reminderUser.Name + \" to you\"];

			const delta = (reminder.Schedule)
				? ` (${sb.Utils.timeDelta(reminder.Schedule)})`
				: \"\";

			return {
				reply: `${owner} ID ${ID} ${target}${delta}: ${reminder.Text} ${alreadyFired}`
			}
		}

		case \"poll\": {
			if (identifier && !Number(identifier)) {
				return {
					reply: \"Invalid ID provided!\"
				};
			}

			const poll = await sb.Query.getRecordset(rs => {
				rs.select(\"Text\", \"Status\", \"End\", \"ID\")
					.from(\"chat_data\", \"Poll\")
					.single();

				if (identifier) {
					rs.where(\"ID = %n\", Number(identifier));
				}
				else {
					rs.orderBy(\"ID DESC\").limit(1);
				}

				return rs;
			});

			if (!poll) {
				return {
					reply: \"No polls match the ID provided!\"
				};
			}
			else if (poll.Status === \"Cancelled\" || poll.Status === \"Active\") {
				const delta = (poll.End < sb.Date.now())
					? \"already ended.\"
					: `ends in ${sb.Utils.timeDelta(poll.End)}.`;

				return {
					reply: `Poll ID ${poll.ID} ${delta} (${poll.Status}) - ${poll.Text}`
				};
			}

			const votes = await sb.Query.getRecordset(rs => rs
				.select(\"Vote\")
				.from(\"chat_data\", \"Poll_Vote\")
				.where(\"Poll = %n\", poll.ID)
			);

			const [yes, no] = sb.Utils.splitByCondition(votes, i => i.Vote === \"Yes\");
			return {
				reply: `Poll ID ${poll.ID} (${poll.Status}) - ${poll.Text} - Votes: ${yes.length}:${no.length}`
			}
		}

		case \"reset\": {
			const last = await sb.Query.getRecordset(rs => rs
				.select(\"Timestamp\")
				.from(\"data\", \"Reset\")
				.where(\"User_Alias = %n\", context.user.ID)
				.orderBy(\"ID DESC\")
				.limit(1)
				.single()
			);

			return {
				reply: (last)
					? `Your last \"reset\" was ${sb.Utils.timeDelta(last.Timestamp)}.`
					: `You have never noted down a \"reset\" before.`
			}
		}

		case \"suggest\":
		case \"suggestion\":
		case \"suggestions\": {
			if (!identifier) {
				return {
					reply: sb.Utils.tag.trim `
						Check all suggestions: https://supinic.com/bot/suggestions/list
						||
						Your suggestions (requires login): https://supinic.com/bot/suggestions/mine
					`
				};
			}

			const row = await sb.Query.getRow(\"data\", \"Suggestion\");
			try {
				await row.load(Number(identifier));
			}
			catch {
				return { reply: \"No such suggestion exists!\" };
			}

			const {
				ID,
				Date: date, 
				Last_Update: update,
				Status: status,
				Text: text,
				User_Alias: user
			} = row.values;
			
			if (status === \"Quarantined\") {
				return {
					reply: \"This suggestion has been quarantined.\"
				};
			}

			const updated = (update)
				? `, last updated ${sb.Utils.timeDelta(update)}`
				: \"\";
			
			const userData = await sb.User.get(user, true);
			return {
				reply: sb.Utils.tag.trim `
					Suggestion ID ${ID}
					from ${userData.Name}: 
					status ${status}
					(posted ${sb.Utils.timeDelta(date)}${updated}):
					${text}
				`
			};
		}

		default: return {
			reply: \"No valid type provided! Please see the help of this command for more info.\"
		};
	}
})',
		'async (prefix) => {

	return [
		\"Checks variables that have been set within supibot\",
		\"\",
		\"These are the same thing: \",
		prefix + \"check notify (ID) => Reminder ID (ID) from (X) to (Y)\",
		prefix + \"check notification (ID) => Reminder ID (ID) from (X) to (Y)\",
		prefix + \"check notifications (ID) => Reminder ID (ID) from (X) to (Y)\",
		prefix + \"check reminder (ID) => Reminder ID (ID) from (X) to (Y)\",
		prefix + \"check reminders (ID) => Reminder ID (ID) from (X) to (Y)\",
		\"\",
		prefix + \"check afk (user) => Posts the AFK status of given user\",
		\"\",
		prefix + \"check suggest/suggestion (ID) => Posts info about a given suggestion, if you made it.\",
		\"\",
		prefix + \"check cookie => Checks if you have eaten your cookie today\",
		prefix + \"check cookie (user) => Checks if given user has eaten their cookie today\"
	
	];
}'
	)