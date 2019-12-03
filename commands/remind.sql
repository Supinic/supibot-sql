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
		30,
		'remind',
		'[\"notify\", \"reminder\", \"remindme\", \"notifyme\", \"remindprivate\", \"notifyprivate\"]',
		'Sets a notify for a given user. Can also set a time to ping that user (or yourself) in given amount of time, but in that case you must use the word \"in\" and then a number specifying the amount days, hours, minutes, etc.',
		10000,
		0,
		0,
		0,
		0,
		NULL,
		0,
		1,
		1,
		1,
		1,
		0,
		'(async function remind (context, ...args) {
	if (args.length === 0) {
		return { reply: \"Not enough info provided!\", meta: { skipCooldown: true } };
	}

	const originalArgs = args.slice(0);
	let targetUser = await sb.Utils.getDiscordUserDataFromMentions(args[0].toLowerCase(), context.append) || await sb.User.get(args[0], true);
	if (context.invocation.includes(\"me\") || args[0] === \"me\" || (targetUser && targetUser.ID === context.user.ID)) {
		targetUser = context.user;

		if (!context.invocation.includes(\"me\")) {
			args.shift();
		}
	}
	else if (!targetUser) {
		return { reply: \"An invalid user was provided!\", meta: { skipCooldown: true } };
	}
	else if (targetUser.Name === sb.Config.get(\"SELF\")) {
		return { reply: \"I\'m always here, so you don\'t have to \" + context.invocation + \" me :)\", meta: { skipCooldown: true } };
	}
	else {
		args.shift();
	}

	let isPrivate = context.invocation.includes(\"private\");
	for (let i = 0; i < args.length; i++) {
		const token = args[i];

		if (token === \"private:true\") {
			isPrivate = true;
			args.splice(i, 1);
		}
	}

	if (isPrivate && context.channel !== null) {
		return {
			reply: \"Do not attempt to set private reminders outside of private messages!\"
		};
	}

	const specificFilter = sb.Filter.data.find(i => (
		i.User_Alias === targetUser.ID
		&& i.Type === \"Block\"
		&& i.Blocked_User === context.user.ID
		&& i.Command === context.command.ID
		&& i.Active
	));
	if (specificFilter) {
		return {
			reply: \"That user has opted out from being reminded by you! 🚫\"
		};
	}

	let timestamp = null;
	const now = new sb.Date();
	const timeIndex = args.lastIndexOf(\"in\");
	if (timeIndex !== -1 && args[timeIndex + 1] && /^-?\\d+/.test(args[timeIndex + 1])) {
		const timeString = args.splice(timeIndex).join(\" \");
		let delta = null;

		try {
			delta = sb.Utils.parseDuration(timeString, \"ms\");
			timestamp = new sb.Date(sb.Date.now() + delta);
		}
		catch (e) {
			return { reply: e.message };
		}

		if (now > timestamp) {
			return { reply: \"Timed reminders in the past are only available for people that posess a time machine!\" };
		}
		// Special case, if the keyword \"in\" is found, but not in a time context, treat the reminder as a non-timed one
		else if (delta === 0) {
			if (targetUser === context.user) {
				return {
					reply: \"Invalid time description provided!\"
				};
			}

			timestamp = null;
			args = originalArgs;
		}
		else if (Math.abs(now - timestamp) < 30.0e3) {
			return { reply: \"You cannot set a timed reminder in less than 30 seconds!\", meta: { skipCooldown: true } };
		}
		else if (timestamp.valueOf() > sb.Config.get(\"SQL_DATETIME_LIMIT\")) {
			return {
				reply: \"Unfortunately, only dates within the SQL DATETIME range are supported - up to Dec 31st 9999\",
				meta: { skipCooldown: true }
			};
		}
		else if (!timestamp.valueOf()) {
			return { reply: \"Invalid time description!\", meta: { skipCooldown: true } };
		}
	}
	else if (targetUser === context.user) {
		return { reply: \"If you want to remind yourself, you must use a timed reminder!\" };
	}

	const text = args.join(\" \") || null;
	let resultID = null;

	try {
		resultID = await sb.Reminder.create({
			Channel: context?.channel?.ID ?? null,
			Platform: context.platform.ID,
			User_From: context.user.ID,
			User_To: targetUser.ID,
			Text: text || \"(no message)\",
			Schedule: timestamp,
			Created: new sb.Date(),
			Private_Message: isPrivate
		});
	}
	catch (e) {
		return { reply: e.message };
	}

	const reply = [
		\"I will remind\",
		(targetUser.ID === context.user.ID) ? \"you\" : targetUser.Name,
		(timestamp)
			? sb.Utils.timeDelta(new sb.Date().addMilliseconds(timestamp - now))
			: \"when they next type in chat\",
		\"(ID \" + resultID + \")\"
	].join(\" \");

	return { reply: reply };
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function remind (context, ...args) {
	if (args.length === 0) {
		return { reply: \"Not enough info provided!\", meta: { skipCooldown: true } };
	}

	const originalArgs = args.slice(0);
	let targetUser = await sb.Utils.getDiscordUserDataFromMentions(args[0].toLowerCase(), context.append) || await sb.User.get(args[0], true);
	if (context.invocation.includes(\"me\") || args[0] === \"me\" || (targetUser && targetUser.ID === context.user.ID)) {
		targetUser = context.user;

		if (!context.invocation.includes(\"me\")) {
			args.shift();
		}
	}
	else if (!targetUser) {
		return { reply: \"An invalid user was provided!\", meta: { skipCooldown: true } };
	}
	else if (targetUser.Name === sb.Config.get(\"SELF\")) {
		return { reply: \"I\'m always here, so you don\'t have to \" + context.invocation + \" me :)\", meta: { skipCooldown: true } };
	}
	else {
		args.shift();
	}

	let isPrivate = context.invocation.includes(\"private\");
	for (let i = 0; i < args.length; i++) {
		const token = args[i];

		if (token === \"private:true\") {
			isPrivate = true;
			args.splice(i, 1);
		}
	}

	if (isPrivate && context.channel !== null) {
		return {
			reply: \"Do not attempt to set private reminders outside of private messages!\"
		};
	}

	const specificFilter = sb.Filter.data.find(i => (
		i.User_Alias === targetUser.ID
		&& i.Type === \"Block\"
		&& i.Blocked_User === context.user.ID
		&& i.Command === context.command.ID
		&& i.Active
	));
	if (specificFilter) {
		return {
			reply: \"That user has opted out from being reminded by you! 🚫\"
		};
	}

	let timestamp = null;
	const now = new sb.Date();
	const timeIndex = args.lastIndexOf(\"in\");
	if (timeIndex !== -1 && args[timeIndex + 1] && /^-?\\d+/.test(args[timeIndex + 1])) {
		const timeString = args.splice(timeIndex).join(\" \");
		let delta = null;

		try {
			delta = sb.Utils.parseDuration(timeString, \"ms\");
			timestamp = new sb.Date(sb.Date.now() + delta);
		}
		catch (e) {
			return { reply: e.message };
		}

		if (now > timestamp) {
			return { reply: \"Timed reminders in the past are only available for people that posess a time machine!\" };
		}
		// Special case, if the keyword \"in\" is found, but not in a time context, treat the reminder as a non-timed one
		else if (delta === 0) {
			if (targetUser === context.user) {
				return {
					reply: \"Invalid time description provided!\"
				};
			}

			timestamp = null;
			args = originalArgs;
		}
		else if (Math.abs(now - timestamp) < 30.0e3) {
			return { reply: \"You cannot set a timed reminder in less than 30 seconds!\", meta: { skipCooldown: true } };
		}
		else if (timestamp.valueOf() > sb.Config.get(\"SQL_DATETIME_LIMIT\")) {
			return {
				reply: \"Unfortunately, only dates within the SQL DATETIME range are supported - up to Dec 31st 9999\",
				meta: { skipCooldown: true }
			};
		}
		else if (!timestamp.valueOf()) {
			return { reply: \"Invalid time description!\", meta: { skipCooldown: true } };
		}
	}
	else if (targetUser === context.user) {
		return { reply: \"If you want to remind yourself, you must use a timed reminder!\" };
	}

	const text = args.join(\" \") || null;
	let resultID = null;

	try {
		resultID = await sb.Reminder.create({
			Channel: context?.channel?.ID ?? null,
			Platform: context.platform.ID,
			User_From: context.user.ID,
			User_To: targetUser.ID,
			Text: text || \"(no message)\",
			Schedule: timestamp,
			Created: new sb.Date(),
			Private_Message: isPrivate
		});
	}
	catch (e) {
		return { reply: e.message };
	}

	const reply = [
		\"I will remind\",
		(targetUser.ID === context.user.ID) ? \"you\" : targetUser.Name,
		(timestamp)
			? sb.Utils.timeDelta(new sb.Date().addMilliseconds(timestamp - now))
			: \"when they next type in chat\",
		\"(ID \" + resultID + \")\"
	].join(\" \");

	return { reply: reply };
})'