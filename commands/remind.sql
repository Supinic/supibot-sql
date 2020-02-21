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
	let deprecationNotice = \"\";
	if (args.length === 0) {
		return { reply: \"Not enough info provided!\", meta: { skipCooldown: true } };
	}
	else if (sb.User.bots.has(context.user.ID)) {
		deprecationNotice = \"Deprecation notice :) Bots should be using Supibot reminder API!\";
	}

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

	const blocked = await sb.Filter.checkBlocks(targetUser, context.user, context.command.ID);
	if (blocked) {
		return {
			reply: blocked
		};
	}

	let delta = 0;
	let reminderText = args.join(\" \");
	const now = new sb.Date();
	const timeData = sb.Utils.parseDuration(reminderText, { returnData: true });

	let lastRange = 0;
	for (const {start, string, end, time} of timeData.ranges) {
		const prefix = reminderText.slice(start - 3, start);
		console.log({string, start, end, time, delta, lastRange})

		if (prefix === \"in \" || ((start - lastRange) === 1)) {
			lastRange = end;
			delta += time;

			const shift = (prefix === \"in \") ? 3 : 0;
			reminderText = reminderText.slice(0, start - shift) + \" \".repeat(end - start + shift) + reminderText.slice(end);
		}
	}

	if (reminderText) {
		reminderText = reminderText.replace(/\\s{2,}/g, \" \").replace(/^ /, \"\");
	}

	const comparison = new sb.Date(now.valueOf() + delta);

	if (delta === 0) {
		if (targetUser === context.user) {
			return {
				reply: \"If you want to remind yourself, you must use a timed reminder!\"
			};
		}
	}
	else if (now > comparison) {
		return { reply: \"Timed reminders in the past are only available for people that posess a time machine!\" };
	}
	else if (Math.abs(now - comparison) < 30.0e3) {
		return { reply: \"You cannot set a timed reminder in less than 30 seconds!\", meta: { skipCooldown: true } };
	}
	else if (comparison > sb.Config.get(\"SQL_DATETIME_LIMIT\")) {
		return {
			reply: \"Unfortunately, only dates within the SQL DATETIME range are supported - up to Dec 31st 9999\",
			meta: { skipCooldown: true }
		};
	}
	else if (!Number.isFinite(comparison.valueOf())) {
		return { reply: \"Invalid time description!\", meta: { skipCooldown: true } };
	}

	// If it is a timed reminder via PMs, only allow it if it a self reminder.
	// Scheduled reminders for users via PMs violate the philosophy of reminders.
	if (context.privateMessage && delta !== 0) {
		if (targetUser === context.user) {
			isPrivate = true;
		}
		else {
			return {
				reply: \"You cannot set a timed reminder for someone else via private messages!\"
			};
		}
	}

	let resultID = null;
	const timestamp = (delta === 0) ? null : new sb.Date(now.valueOf() + delta);
	try {
		resultID = await sb.Reminder.create({
			Channel: context?.channel?.ID ?? null,
			Platform: context.platform.ID,
			User_From: context.user.ID,
			User_To: targetUser.ID,
			Text: reminderText || \"(no message)\",
			Schedule: timestamp,
			Created: new sb.Date(),
			Private_Message: isPrivate
		});
	}
	catch (e) {
		return { reply: e.message };
	}

	const reply = [
		deprecationNotice,
		\"I will\" + (isPrivate ? \" privately\" : \"\") + \" remind\",
		(targetUser.ID === context.user.ID) ? \"you\" : targetUser.Name,
		(timestamp)
			? sb.Utils.timeDelta(timestamp)
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
	let deprecationNotice = \"\";
	if (args.length === 0) {
		return { reply: \"Not enough info provided!\", meta: { skipCooldown: true } };
	}
	else if (sb.User.bots.has(context.user.ID)) {
		deprecationNotice = \"Deprecation notice :) Bots should be using Supibot reminder API!\";
	}

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

	const blocked = await sb.Filter.checkBlocks(targetUser, context.user, context.command.ID);
	if (blocked) {
		return {
			reply: blocked
		};
	}

	let delta = 0;
	let reminderText = args.join(\" \");
	const now = new sb.Date();
	const timeData = sb.Utils.parseDuration(reminderText, { returnData: true });

	let lastRange = 0;
	for (const {start, string, end, time} of timeData.ranges) {
		const prefix = reminderText.slice(start - 3, start);
		console.log({string, start, end, time, delta, lastRange})

		if (prefix === \"in \" || ((start - lastRange) === 1)) {
			lastRange = end;
			delta += time;

			const shift = (prefix === \"in \") ? 3 : 0;
			reminderText = reminderText.slice(0, start - shift) + \" \".repeat(end - start + shift) + reminderText.slice(end);
		}
	}

	if (reminderText) {
		reminderText = reminderText.replace(/\\s{2,}/g, \" \").replace(/^ /, \"\");
	}

	const comparison = new sb.Date(now.valueOf() + delta);

	if (delta === 0) {
		if (targetUser === context.user) {
			return {
				reply: \"If you want to remind yourself, you must use a timed reminder!\"
			};
		}
	}
	else if (now > comparison) {
		return { reply: \"Timed reminders in the past are only available for people that posess a time machine!\" };
	}
	else if (Math.abs(now - comparison) < 30.0e3) {
		return { reply: \"You cannot set a timed reminder in less than 30 seconds!\", meta: { skipCooldown: true } };
	}
	else if (comparison > sb.Config.get(\"SQL_DATETIME_LIMIT\")) {
		return {
			reply: \"Unfortunately, only dates within the SQL DATETIME range are supported - up to Dec 31st 9999\",
			meta: { skipCooldown: true }
		};
	}
	else if (!Number.isFinite(comparison.valueOf())) {
		return { reply: \"Invalid time description!\", meta: { skipCooldown: true } };
	}

	// If it is a timed reminder via PMs, only allow it if it a self reminder.
	// Scheduled reminders for users via PMs violate the philosophy of reminders.
	if (context.privateMessage && delta !== 0) {
		if (targetUser === context.user) {
			isPrivate = true;
		}
		else {
			return {
				reply: \"You cannot set a timed reminder for someone else via private messages!\"
			};
		}
	}

	let resultID = null;
	const timestamp = (delta === 0) ? null : new sb.Date(now.valueOf() + delta);
	try {
		resultID = await sb.Reminder.create({
			Channel: context?.channel?.ID ?? null,
			Platform: context.platform.ID,
			User_From: context.user.ID,
			User_To: targetUser.ID,
			Text: reminderText || \"(no message)\",
			Schedule: timestamp,
			Created: new sb.Date(),
			Private_Message: isPrivate
		});
	}
	catch (e) {
		return { reply: e.message };
	}

	const reply = [
		deprecationNotice,
		\"I will\" + (isPrivate ? \" privately\" : \"\") + \" remind\",
		(targetUser.ID === context.user.ID) ? \"you\" : targetUser.Name,
		(timestamp)
			? sb.Utils.timeDelta(timestamp)
			: \"when they next type in chat\",
		\"(ID \" + resultID + \")\"
	].join(\" \");

	return { reply: reply };
})'