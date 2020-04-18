INSERT INTO
	`chat_data`.`Command`
	(
		ID,
		Name,
		Aliases,
		Flags,
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
		Owner_Override,
		Archived,
		Static_Data,
		Code,
		Examples,
		Dynamic_Description
	)
VALUES
	(
		76,
		'subscribe',
		'[\"unsubscribe\"]',
		NULL,
		'Subscribe or unscribe to a database changing event. Currently supported: \"Suggestion\".',
		5000,
		0,
		0,
		1,
		0,
		NULL,
		0,
		0,
		0,
		1,
		1,
		0,
		0,
		NULL,
		'(async function subscribe (context, type) {
	const allowedTypes = [\"suggestion\"];
	if (!type || !allowedTypes.includes(type.toLowerCase())) {
		return {
			success: false,
			reply: \"Incorrect event provided!\"
		};
	}

	type = sb.Utils.capitalize(type);

	const { invocation } = context;
	const subscription = await sb.Query.getRecordset(rs => rs
		.select(\"ID\", \"Active\")
		.from(\"chat_data\", \"Event_Subscription\")
		.where(\"User_Alias = %n\", context.user.ID)
		.where(\"Type = %s\", type)
		.limit(1)
		.single()
	);

	if (subscription) {
		if (
			(invocation === \"subscribe\" && subscription.Active)
			|| (invocation === \"unsubscribe\" && !subscription.Active)
		) {
			const preposition = (invocation === \"subscribe\") ? \"to\" : \"from\";
			return {
				success: false,
				reply: `You are already ${invocation}d ${preposition} this event!`
			};
		}

		await sb.Query.getRecordUpdater(rs => rs
			.update(\"chat_data\", \"Event_Subscription\")
			.set(\"Active\", !subscription.Active)
			.where(\"ID = %n\", subscription.ID)
		);

		const prefix = (invocation === \"subscribe\") ? \"re\" : \"\";
		return {
			reply: `Sucessfully ${prefix}${invocation}d.`
		};
	}
	else {
		if (invocation === \"unsubscribe\") {
			return {
				success: false,
				reply: `You are not subscribed to this event, so you cannot unsubscribe!`
			};
		}

		const row = await sb.Query.getRow(\"chat_data\", \"Event_Subscription\");
		row.setValues({
			User_Alias: context.user.ID,
			Platform: context.platform.ID,
			Type: type,
			Active: true
		});

		await row.save();
		return {
			reply: `Sucessfully subscribed. You will now receive private reminders.`
		};
	}
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function subscribe (context, type) {
	const allowedTypes = [\"suggestion\"];
	if (!type || !allowedTypes.includes(type.toLowerCase())) {
		return {
			success: false,
			reply: \"Incorrect event provided!\"
		};
	}

	type = sb.Utils.capitalize(type);

	const { invocation } = context;
	const subscription = await sb.Query.getRecordset(rs => rs
		.select(\"ID\", \"Active\")
		.from(\"chat_data\", \"Event_Subscription\")
		.where(\"User_Alias = %n\", context.user.ID)
		.where(\"Type = %s\", type)
		.limit(1)
		.single()
	);

	if (subscription) {
		if (
			(invocation === \"subscribe\" && subscription.Active)
			|| (invocation === \"unsubscribe\" && !subscription.Active)
		) {
			const preposition = (invocation === \"subscribe\") ? \"to\" : \"from\";
			return {
				success: false,
				reply: `You are already ${invocation}d ${preposition} this event!`
			};
		}

		await sb.Query.getRecordUpdater(rs => rs
			.update(\"chat_data\", \"Event_Subscription\")
			.set(\"Active\", !subscription.Active)
			.where(\"ID = %n\", subscription.ID)
		);

		const prefix = (invocation === \"subscribe\") ? \"re\" : \"\";
		return {
			reply: `Sucessfully ${prefix}${invocation}d.`
		};
	}
	else {
		if (invocation === \"unsubscribe\") {
			return {
				success: false,
				reply: `You are not subscribed to this event, so you cannot unsubscribe!`
			};
		}

		const row = await sb.Query.getRow(\"chat_data\", \"Event_Subscription\");
		row.setValues({
			User_Alias: context.user.ID,
			Platform: context.platform.ID,
			Type: type,
			Active: true
		});

		await row.save();
		return {
			reply: `Sucessfully subscribed. You will now receive private reminders.`
		};
	}
})'