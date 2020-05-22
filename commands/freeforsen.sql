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
		219,
		'freeforsen',
		NULL,
		'ping,pipe',
		'Free Forsen forsenE',
		10000,
		NULL,
		'({
	ban: new sb.Date(\"2020-05-08 20:12:52\"),
	supposedExpiry: new sb.Date(\"2020-05-08 20:12:52\").addDays(14),
	expiry: new sb.Date(\"2020-05-22 21:11:12\")
})',
		'(async function () {
	const { ban, expiry } = this.staticData;
	const banDelta = sb.Utils.timeDelta(ban);
	const expiryDelta = sb.Utils.timeDelta(expiry);

	const string = (expiry <= new sb.Date()) 
		? \"has been unbanned\"
		: \"will most likely return\";

	return {
		reply: `forsenE got banned ${banDelta} and ${string} ${expiryDelta}. forsenW`
	};
})',
		NULL
	)