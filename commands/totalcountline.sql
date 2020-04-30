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
		61,
		'totalcountline',
		'[\"acl\", \"tcl\"]',
		NULL,
		'Fetches the total amount of a user\'s (or yours, if nobody was specified) chat lines in all tracked channels summed together.',
		30000,
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
		'(async function totalCountLines (context, target) {
	if (!target) {
		target = context.user;
	}

	const userData = await sb.User.get(target);
	if (!userData)  {
		return { 
			reply: `That user was not found in the database!`
		};
	}	

	const data = (await sb.Query.getRecordset(rs => rs
		.select(\"SUM(Message_Count) AS Total\")
		.from(\"chat_data\", \"Message_Meta_User_Alias\")
		.where(\"User_Alias = %n\", userData.ID)
		.single()
	));
	
	if (data.Total === null) {
		return { 
			reply: `That user is being tracked, but they have not said any lines in the channels I watch.`
		};
	}

	const who = (context.user.ID === userData.ID) ? \"You have\" : \"That user has\";
	return { 
		reply: `${who} sent ${data.Total} chat lines across all tracked channels so far.`
	};
})',
		NULL,
		NULL
	)