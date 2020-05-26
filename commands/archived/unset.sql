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
		63,
		'unset',
		NULL,
		'archived,ping,pipe',
		'Unsets a certain variable that you have created (e.g. reminders)',
		5000,
		NULL,
		'({
	variables: [
		{
			names: [\"notify\", \"reminder\"],
			description: \"Unsets an active reminder either set by you or for you.\"
		},
		{
			names: [\"suggest\", \"suggestion\"],
			description: \"Marks an active suggestion created by you to be \\\"Dismissed by author\\\".\"
		},
		{
			names: [\"location\"],
			description: \"Removes your location if you have set one before.\"
		}
	]
})',
		'(async function unset (context, type, ID) {
	if (!type) {
		return {
			success: false,
			reply: \"No type provided!\"
		};
	}

	type = type.toLowerCase();
	if (ID === \"last\") {
		let result = null;
		if (type === \"notify\" || type === \"reminder\") {
			result = await sb.Query.getRecordset(rs => rs
				.select(\"ID\")
				.from(\"chat_data\", \"Reminder\")
				.where(\"User_From = %n\", context.user.ID)
				.where(\"Active = %b\", true)
				.orderBy(\"ID DESC\")
				.limit(1)
				.single()
			);

		}
		else if (type === \"suggestion\" || type === \"suggest\") {
			result = await sb.Query.getRecordset(rs => rs
				.select(\"ID\")
				.from(\"data\", \"Suggestion\")
				.where(\"User_Alias = %n\", context.user.ID)
				.orderBy(\"ID DESC\")
				.limit(1)
				.single()
			);
		}
		else {
			return { reply: `Unsupported type for the keyword \"last\"!` };
		}

		if (!result) {
			return { reply: `No suitable \"last\" ${type} ID for you has been found!` };
		}
		else {
			ID = result.ID;
		}
	}

	ID = Number(ID);
	switch (type) {
		case \"ambassador\": {
			if (!context.user.Data.administrator) {
				return {
					success: false,
					reply: `Only administrators can use this invocation!`
				};
			}

			const [user, channel = context.channel?.Name] = args;
			if (!user || !channel) {
				return {
					success: false,
					reply: `Must provide a proper user and channel!`
				};
			}

			const userData = await sb.User.get(user);
			const channelData = sb.Channel.get(channel, context.platform);
			if (!userData || !channelData) {
				return {
					success: false,
					reply: `Either channel or user have not been found!`
				};
			}

			if (!channelData.isUserAmbassador(userData)) {
				return {
					success: false,
					reply: `That user is not an ambassador in #${channelData.Name}!`
				};
			}

			await channelData.toggleAmbassador(userData);

			return {
				reply: `${userData.Name} is no longer an ambassador in #${channelData.Name}.`
			};
		}

		case \"gc\": {
			const row = await sb.Query.getRow(\"music\", \"Track\");
			try {
				await row.load(ID);
			}
			catch {
				return {
					success: false,
					reply: \"ID does not exist!\"
				};
			}

			if (!context.user.Data.administrator && row.values.Added_By !== context.user.ID) {
				return {
					success: false,
					reply: \"This track was not added by you!\"
				};
			}

			const tags = (await sb.Query.getRecordset(rs => rs
				.select(\"Tag\")
				.from(\"music\", \"Track_Tag\")
				.where(\"Track = %n\", ID)
			)).map(i => i.Tag);

			// If gachi tag is present already, there is no reason to unset it.
			if (tags.includes(6)) {
				return {
					success: false,
					reply: \"This track has already been categorized, and cannot be changed like this!\"
				};
			}

			// Deletes TODO tag of given track.
			await sb.Query.raw(`DELETE FROM music.Track_Tag WHERE (Track = ${ID} AND Tag = 20)`);

			return {
				reply: `Track ${ID} has been stripped of the TODO tag.`
			};
		}

		case \"notify\":
		case \"reminder\": {
			const row = await sb.Query.getRow(\"chat_data\", \"Reminder\");
			try {
				await row.load(ID);
			}
			catch {
				return {
					success: false,
					reply: \"ID does not exist!\"
				};
			}

			if (row.values.User_From !== context.user.ID && row.values.User_To !== context.user.ID ) {
				return {
					success: false,
					reply: \"That reminder was not created by you or set for you!\"
				};
			}
			else if (!row.values.Active) {
				return {
					success: false,
					reply: \"That reminder is already deactivated!\"
				};
			}
			else if (context.channel?.ID && !row.values.Schedule && row.values.User_To === context.user.ID) {
				return {
					success: false,
					reply: \"Good job, trying to unset a reminder that just fired PepeLaugh\"
				};
			}
			else {
				const reminder = sb.Reminder.get(ID);
				if (reminder) {
					await reminder.deactivate(true);
				}
				else {
					row.values.Active = false;
					await row.save();
				}

				return {
					reply: `Reminder ID ${ID} unset successfully.`
				};
			}
		}

		case \"suggest\":
		case \"suggestion\": {
			let row = await sb.Query.getRow(\"data\", \"Suggestion\");
			try {
				await row.load(ID);
			}
			catch {
				return { reply: \"ID does not exist!\" };
			}

			if (row.values.User_Alias !== context.user.ID) {
				return { reply: \"That suggestion was not created by you!\" };
			}
			else if (row.values.Status === \"Dismissed by author\") {
				return { reply: \"That reminder is already deactivated!\" };
			}
			else {
				row.values.Priority = null;
				row.values.Status = \"Dismissed by author\";
				await row.save();
				return { reply: \"Suggestion ID \" + ID + \" has been flagged as \\\"Dismissed by author\\\".\" };
			}
		}

		case \"location\": {
			context.user.Data.location = null;

			await context.user.saveProperty(\"Data\", context.user.Data);
			return {
				reply: \"Your location has been unset successfully!\"
			};
		}

		default: return {
			success: false,
			reply: \"Unrecognized target!\"
		};
	}
})',
		'async (prefix, values) => {	
	const { variables } = values.getStaticData();
	const list = variables.map(i => `<li><code>${i.names.join(\"/\")}</code> ${i.description}</li>`).join(\"\");

	return [
		\"Unsets a variable that you have set in Supibot beforehand.\",
		\"\",

		`<code>${prefix}unset (variable) (ID)</code>`,
		`Unsets the variable of the given type, and the given ID.`,
		\"\",
		

		`<code>${prefix}unset (variable) last</code>`,
		`If applicable, unsets the last variable of given that type that you have set.`,
		\"\",

		\"List of variables:\",
		`<ul>${list}</ul>`		
	];	
}',
		'supinic/supibot-sql'
	)