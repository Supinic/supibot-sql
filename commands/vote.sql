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
		142,
		'vote',
		'[\"poll\"]',
		'ping,pipe',
		'If there is poll running, you can vote \"yes\" or \"no\", if you don\'t post either you will get the currently running poll (or nothing if there\'s none)',
		5000,
		NULL,
		NULL,
		'(async function vote (context, vote) {
	const poll = await sb.Query.getRecordset(rs => rs
		.select(\"ID\", \"Text\", \"End\")
		.from(\"chat_data\", \"Poll\")
		.where(\"Status = %s\", \"Active\")
		.where(\"End > NOW()\")
		.orderBy(\"ID DESC\")
		.limit(1)
		.single()
	);

	if (!poll) {
		return { reply: \"There is no currently running poll!\" };
	}

	const votedAlready = await sb.Query.getRecordset(rs => rs
		.select(\"1\")
		.from(\"chat_data\", \"Poll_Vote\")
		.where(\"Poll = %n\", poll.ID)
		.where(\"User_Alias = %n\", context.user.ID)
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
			User_Alias: context.user.ID,
			Vote: vote
		});
		await row.save();

		return { reply: \"Successfully voted.\" };
	}
})',
		NULL,
		'supinic/supibot-sql'
	)