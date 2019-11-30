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
		142,
		'vote',
		'[\"poll\"]',
		'If there is poll running, you can vote \"yes\" or \"no\", if you don\'t post either you will get the currently running poll (or nothing if there\'s none)',
		5000,
		0,
		0,
		0,
		0,
		NULL,
		0,
		0,
		0,
		1,
		1,
		0,
		'async (extra, vote) => {
	const poll = await sb.Query.getRecordset(rs => rs
		.select(\"ID\", \"Text\", \"End\")
		.from(\"chat_data\", \"Poll\")
		.where(\"Status = %s\", \"Active\")
		.single()
	);

	if (!poll) {
		return { reply: \"There is no currently running poll!\" };
	}

	const votedAlready = await sb.Query.getRecordset(rs => rs
		.select(\"1\")
		.from(\"chat_data\", \"Poll_Vote\")
		.where(\"Poll = %n\", poll.ID)
		.where(\"User_Alias = %n\", extra.user.ID)
		.single()
	);

	if (!vote) {
		const voted = (votedAlready) ? \"You already voted.\" : \"\";
		return { 
			reply: `${poll.Text} -- ends ${sb.Utils.timeDelta(poll.End)}. ${voted}`
		};
	}

	vote = vote.toLowerCase();
	if (![\"yes\", \"no\"].includes(vote)) {
		return { reply: \"You can only vote with \\\"yes\\\" or \\\"no\\\"!\" };
	}	
	
	if (votedAlready) {
		return { reply: \"You already voted on this poll!\" };
	}
	else {
		const row = await sb.Query.getRow(\"chat_data\", \"Poll_Vote\");
		row.setValues({
			Poll: poll.ID,
			User_Alias: extra.user.ID,
			Vote: vote
		});
		await row.save();

		return { reply: \"Sucessfully voted.\" };
	}
}',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async (extra, vote) => {
	const poll = await sb.Query.getRecordset(rs => rs
		.select(\"ID\", \"Text\", \"End\")
		.from(\"chat_data\", \"Poll\")
		.where(\"Status = %s\", \"Active\")
		.single()
	);

	if (!poll) {
		return { reply: \"There is no currently running poll!\" };
	}

	const votedAlready = await sb.Query.getRecordset(rs => rs
		.select(\"1\")
		.from(\"chat_data\", \"Poll_Vote\")
		.where(\"Poll = %n\", poll.ID)
		.where(\"User_Alias = %n\", extra.user.ID)
		.single()
	);

	if (!vote) {
		const voted = (votedAlready) ? \"You already voted.\" : \"\";
		return { 
			reply: `${poll.Text} -- ends ${sb.Utils.timeDelta(poll.End)}. ${voted}`
		};
	}

	vote = vote.toLowerCase();
	if (![\"yes\", \"no\"].includes(vote)) {
		return { reply: \"You can only vote with \\\"yes\\\" or \\\"no\\\"!\" };
	}	
	
	if (votedAlready) {
		return { reply: \"You already voted on this poll!\" };
	}
	else {
		const row = await sb.Query.getRow(\"chat_data\", \"Poll_Vote\");
		row.setValues({
			Poll: poll.ID,
			User_Alias: extra.user.ID,
			Vote: vote
		});
		await row.save();

		return { reply: \"Sucessfully voted.\" };
	}
}'