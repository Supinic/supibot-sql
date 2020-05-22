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
		30,
		'remind',
		'[\"notify\", \"reminder\", \"remindme\", \"notifyme\", \"remindprivate\", \"notifyprivate\"]',
		'block,opt-out,ping,pipe',
		'Sets a notify for a given user. Can also set a time to ping that user (or yourself) in given amount of time, but in that case you must use the word \"in\" and then a number specifying the amount days, hours, minutes, etc.',
		10000,
		NULL,
		'({
	strings: {
		\"scheduled-incoming\": \"That person has too many timed reminders pending for them on that day!\",
		\"public-incoming\": \"That person has too many public reminders pending!\",
		\"public-outgoing\":  \"You have too many public reminders pending!\",
		\"private-incoming\": \"That person has too many private reminders pending!\",
		\"private-outgoing\": \"You have too many private reminders pending!\"
	}
})',
		'(async function remind (context, ...args) {
	let deprecationNotice = \"\";
	if (args.length === 0) {
		return { reply: \"Not enough info provided!\", meta: { skipCooldown: true } };
	}
	else if (sb.User.bots.has(context.user.ID)) {
		deprecationNotice = \"Deprecation notice: bots should be using the reminder API! \";
	}

	let targetUser = await sb.Utils.getDiscordUserDataFromMentions(args[0].toLowerCase(), context.append) || await sb.User.get(args[0], true);
	if (context.invocation.includes(\"me\") || args[0] === \"me\" || (targetUser && targetUser.ID === context.user.ID)) {
		targetUser = context.user;

		if (!context.invocation.includes(\"me\")) {
			args.shift();
		}
	}
	else if (!targetUser) {
		return {
			reply: \"An invalid user was provided!\",
			cooldown: this.Cooldown / 2
		};
	}
	else if (targetUser.ID === sb.Config.get(\"SELF_ID\")) {
		return {
			reply: \"I\'m always here, so you don\'t have to \" + context.invocation + \" me :)\",
			cooldown: this.Cooldown / 2
		};
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
			reply: \"You should create private reminders in private messages!\",
			cooldown: this.Cooldown / 2
		};
	}

	let reminderText = args.join(\" \");

	const timedRegex = /\\b(in|on|at)\\b/i;
	let targetReminderDate = null;
	let targetReminderDelta = \"when they next type in chat\";
	let delta = 0;

	const now = new sb.Date();
	if (timedRegex.test(reminderText)) {
		reminderText = reminderText.replace(/\\bhr\\b/g, \"hour\");

		const chronoRegex = /\\bin\\b/;
		const chronoData = sb.Utils.parseChrono(reminderText, null, { forwardDate: true });
		const timeData = sb.Utils.parseDuration(reminderText, { returnData: true });

		if (chronoRegex.test(chronoData?.text ?? \"\")) {
			const isRelative = (Object.keys(chronoData.component.knownValues).length === 0);
			if (targetUser?.Data.location && !isRelative) {
				const location = targetUser.Data.location;
				if (!location.timezone) {
					const time = sb.Command.get(\"time\");
					await time.execute({}, \"@\" + targetUser.Name);
				}

				const { offset } = location.timezone;
				chronoData.component.assign(\"timezoneOffset\", offset / 60);
				targetReminderDate = new sb.Date(chronoData.component.date());
			}
			else {
				targetReminderDate = new sb.Date(chronoData.date);
			}

			if (chronoData.text) {
				reminderText = reminderText.replace(chronoData.text, \"\");
			}

			targetReminderDate.milliseconds = now.milliseconds;
			delta = sb.Utils.round(targetReminderDate - sb.Date.now(), -3);

		}
		else if (timeData.ranges.length > 0) {
			const continueRegex = /^and|[\\s\\W]+$/;
			targetReminderDate = new sb.Date();

			for (let i = 0; i < timeData.ranges.length; i++) {
				const current = timeData.ranges[i];
				const next = timeData.ranges[i + 1];

				delta += current.time;
				targetReminderDate.addMilliseconds(current.time);

				// Parse out the text between ranges, ...
				const between = (next)
					? reminderText.slice(current.end, next.start)
					: \"\";

				// and only continue if it matches a \"time word separator\", such as the word \"and\", space, comma, ...
				if (!continueRegex.test(between)) {
					reminderText = reminderText.slice(0, current.start) + reminderText.slice(current.end);
					break;
				}
				else {
					const amount = next.start - current.start;
					reminderText = reminderText.slice(0, current.start) + \"\\x00\".repeat(amount) + reminderText.slice(next.start);
				}
			}

			if (timeData.ranges[0]?.start) {
				const end = timeData.ranges[0].start;
				const preceder = reminderText.slice(end - 3, end);
				if (timedRegex.test(preceder)) {
					reminderText = reminderText.slice(0, end - 3) + \"\\x00\".repeat(3) + reminderText.slice(end);
				}
			}

			reminderText = reminderText.replace(/\\x00/g, \"\");
		}

		if (delta > 0) {
			targetReminderDelta = sb.Utils.timeDelta(targetReminderDate);
		}
	}

	const comparison = new sb.Date(now.valueOf() + delta);

	if (delta === 0) {
		if (targetUser === context.user) {
			return {
				reply: `To remind yourself, use a timed reminder that uses the keyword \"in\" - such as \"remindme something in 5 minutes\"`,
				cooldown: 2500
			};
		}
	}
	else if (now > comparison) {
		return { reply: \"Timed reminders set in the past are only available for people that posess a time machine!\" };
	}
	else if (Math.abs(now - comparison) < 30.0e3) {
		return {
			reply: \"You cannot set a timed reminder in less than 30 seconds!\",
			cooldown: this.Cooldown / 2
		};
	}
	else if (delta > sb.Config.get(\"SQL_DATETIME_LIMIT\")) {
		const description = (Number.isFinite(comparison.valueOf()))
			? comparison.format(\"Y-m-d\")
			: `${Math.trunc(delta / 31_536_000_000)} years in the future`;

		return {
			reply: `Your reminder was set to approximately ${description}, but the limit is 31st December 9999.`,
			cooldown: this.Cooldown / 2
		};
	}

	// If it is a timed reminder via PMs, only allow it if it a self reminder.
	// Scheduled reminders for users via PMs violate the philosophy of reminders.
	if (context.privateMessage && delta !== 0) {
		if (targetUser === context.user) {
			isPrivate = true;
		}
		else {
			return {
				reply: \"You cannot create a private timed reminder for someone else!\"
			};
		}
	}

	const result = await sb.Reminder.create({
		Channel: context?.channel?.ID ?? null,
		Platform: context.platform.ID,
		User_From: context.user.ID,
		User_To: targetUser.ID,
		Text: reminderText || \"(no message)\",
		Schedule: targetReminderDate ?? null,
		Created: new sb.Date(),
		Private_Message: isPrivate
	});

	if (result.success) {
		const who = (targetUser.ID === context.user.ID) ? \"you\" : targetUser.Name;
		const method = (isPrivate) ? \"privately \" : \"\";

		return {
			reply: `${deprecationNotice}I will ${method}remind ${who} ${targetReminderDelta} (ID ${result.ID})`
		};
	}
	else {
		console.warn(\"Reminder create failed\", result);
		return {
			reply: this.staticData.strings[result.cause] ?? `Reminder not created - result is ${result.cause}.`
		};
	}
})',
		NULL
	)