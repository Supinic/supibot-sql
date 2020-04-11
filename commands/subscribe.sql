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
		'[\"sub\"]',
		NULL,
		'Subscribe to a database changing event. Events: Suggestion (when their status changes) or Gachi (for new tracks in the list). Only one channel per event per user. Use the command again to unsubscribe.',
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
		'async (extra, event) => {
	const allowedEvents = [\"gachi\", \"suggestion\"];
	if (!event || !allowedEvents.includes(event.toLowerCase())) {
		return { reply: \"Incorrect event provided!\" };
	}

	event = sb.Utils.capitalize(event);
	const check = (await sb.Query.getRecordset(rs => rs
		.select(\"ID\")
		.from(\"chat_data\", \"Table_Update_Notification\")
		.where(\"User_Alias = %n\", extra.user.ID)
		.where(\"Event = %s\", event)
	))[0];

	let reply = null;
	const row = await sb.Query.getRow(\"chat_data\", \"Table_Update_Notification\");
	if (check) {
		await row.load(check.ID);
		reply = \"You are now unsubscribed from the event \\\"\" + event + \"\\\" in channel \" + sb.Channel.get(row.values.Channel).Name;
		await row.delete();

		sb.InternalRequest.removeSubscription(check.ID);
	}
	else {
		row.setValues({
			User_Alias: extra.user.ID,
			Channel: extra.channel.ID,
			Event: event
		});

		await row.save();
		sb.InternalRequest.addSubscription(row.valuesObject);

		reply = \"You are now subscribed to the event \\\"\" + event + \"\\\" in this channel.\";
	}

	return { reply: reply };
}',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async (extra, event) => {
	const allowedEvents = [\"gachi\", \"suggestion\"];
	if (!event || !allowedEvents.includes(event.toLowerCase())) {
		return { reply: \"Incorrect event provided!\" };
	}

	event = sb.Utils.capitalize(event);
	const check = (await sb.Query.getRecordset(rs => rs
		.select(\"ID\")
		.from(\"chat_data\", \"Table_Update_Notification\")
		.where(\"User_Alias = %n\", extra.user.ID)
		.where(\"Event = %s\", event)
	))[0];

	let reply = null;
	const row = await sb.Query.getRow(\"chat_data\", \"Table_Update_Notification\");
	if (check) {
		await row.load(check.ID);
		reply = \"You are now unsubscribed from the event \\\"\" + event + \"\\\" in channel \" + sb.Channel.get(row.values.Channel).Name;
		await row.delete();

		sb.InternalRequest.removeSubscription(check.ID);
	}
	else {
		row.setValues({
			User_Alias: extra.user.ID,
			Channel: extra.channel.ID,
			Event: event
		});

		await row.save();
		sb.InternalRequest.addSubscription(row.valuesObject);

		reply = \"You are now subscribed to the event \\\"\" + event + \"\\\" in this channel.\";
	}

	return { reply: reply };
}'