INSERT INTO
	`chat_data`.`Cron`
	(
		ID,
		Name,
		Expression,
		Description,
		Code,
		Type,
		Active
	)
VALUES
	(
		17,
		'suggestion-notification-system',
		'0 * * * * *',
		'Manages sending notifications about suggestions being changed. This is to notify users (via private system reminders) that their suggestion\'s status has changed.',
		'(async function notifyOnSuggestionChange () {
	const subscriptions = await sb.Query.getRecordset(rs => rs
		.select(\"User_Alias\", \"Platform\")
		.from(\"chat_data\", \"Event_Subscription\")
		.where(\"Active = %b\", true)
		.where(\"Type = %s\", \"Suggestion\")
	);		
	const users = subscriptions.map(i => i.User_Alias);

	const suggestions = await sb.Query.getRecordset(rs => rs
		.select(\"ID\", \"User_Alias\", \"Status\")
		.from(\"data\", \"Suggestion\")
		.where(\"Status NOT IN %s+\", [\"Dismissed by author\", \"Quarantined\"])
		.where(\"User_Alias IN %n+\", users)
		.orderBy(\"ID DESC\")
	);

	if (!this.data.previousSuggestions) {
		this.data.previousSuggestions = suggestions;
		return;
	}

	for (const oldRow of this.data.previousSuggestions) {
		const newRow = suggestions.find(i => i.ID === oldRow.ID);
		if (!newRow) {
			continue;
		}

		const sub = subscriptions.find(i => i.User_Alias === oldRow.User_Alias);
		if (oldRow.Status !== newRow.Status) {
			await sb.Reminder.create({
				Channel: null,
				Platform: sub.Platform,
				User_From: sb.Config.get(\"SELF_ID\"),
				User_To: oldRow.User_Alias,
				Text: `[EVENT] Suggestion ${oldRow.ID} changed: ${oldRow.Status} => ${newRow.Status}`,
				Schedule: null,
				Created: new sb.Date(),
				Private_Message: true
			});
		}
	}

	this.data.previousSuggestions = suggestions;
})',
		'Bot',
		1
	)