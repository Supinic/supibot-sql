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
		Static_Data,
		Code,
		Examples,
		Dynamic_Description
	)
VALUES
	(
		210,
		'randomname',
		'[\"rn\"]',
		'Fetches a random name.',
		10000,
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
		'({
	types: [
		\"Human Male\",
		\"Human Female\",
		\"Dwarwish Male\",
		\"Dwarwish Female\",
		\"Elvish Male\",
		\"Elvish Female\",
		\"Halfling Male\",
		\"Halfling Female\",

		\"Draconic Male\",
		\"Draconic Female\",
		\"Drow Male\",
		\"Drow Female\",
		\"Orcish Male\",
		\"Orcish Female\",

		\"Fiendish\",
		\"Celestial\",
		\"Modron\"
	]
})',
		'(async function randomName (context, type) {
	if (!type) {
		type = sb.Utils.randArray(this.staticData.types);
	}

	const name = await sb.Got({
	  	url: \"https://donjon.bin.sh/name/rpc-name.fcgi\",
		searchParams: new sb.URLParams()
			.set(\"type\", type)
			.set(\"n\", \"1\")
			.toString()
	}).text();

	return {
		reply: `Your random ${type} name is: ${name}`
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function randomName (context, type) {
	if (!type) {
		type = sb.Utils.randArray(this.staticData.types);
	}

	const name = await sb.Got({
	  	url: \"https://donjon.bin.sh/name/rpc-name.fcgi\",
		searchParams: new sb.URLParams()
			.set(\"type\", type)
			.set(\"n\", \"1\")
			.toString()
	}).text();

	return {
		reply: `Your random ${type} name is: ${name}`
	};
})'