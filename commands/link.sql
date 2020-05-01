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
		214,
		'link',
		NULL,
		NULL,
		'Verifies your account linking challenge across platforms. You should only ever use this command if you are prompted to.',
		5000,
		0,
		1,
		0,
		0,
		NULL,
		0,
		0,
		0,
		1,
		0,
		0,
		0,
		NULL,
		'(async function link (context, challengeString) {
	if (!context.privateMessage) {
		return {
			success: false,
			reply: `You cannot use this command outside of private messages!`
		};
	}
	else if (!challengeString) {
		return {
			success: false,
			reply: \"If you have a challenge string, use it. If you don\'t have one, don\'t use this command.\"
		};
	}

	const challengeID = await sb.Query.getRecordset(rs => rs
		.select(\"ID\")
		.from(\"chat_data\", \"User_Verification_Challenge\")
		.where(\"User_Alias = %n\", context.user.ID)
		.where(\"Platform_To = %n\", context.platform.ID)
		.where(\"Challenge = %s\", challengeString)
		.where(\"Status = %s\", \"Active\")
		.limit(1)
		.single()
		.flat(\"ID\")
	);

	if (typeof challengeID !== \"number\") {
		return {
			success: false,
			reply: `No active verification found!`
		};
	}

	const row = await sb.Query.getRow(\"chat_data\", \"User_Verification_Challenge\");
	await row.load(challengeID);

	const sourcePlatform = sb.Platform.get(row.values.Platform_From);
	const targetPlatform = sb.Platform.get(row.values.Platform_To);
	
	const idColumnName = sourcePlatform.capital + \"_ID\";
	await context.user.saveProperty(idColumnName, row.values.Specific_ID);
	
	row.values.Status = \"Completed\";
	await row.save();

	return {
		reply: `Verification completed! You may now use the bot on ${sourcePlatform.capital} as well as ${targetPlatform.capital}.`
	};
})',
		NULL,
		NULL
	)