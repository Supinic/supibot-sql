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
		210,
		'randomname',
		'[\"rn\"]',
		'ping,pipe',
		'Fetches a random name.',
		10000,
		NULL,
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
		'supinic/supibot-sql'
	)