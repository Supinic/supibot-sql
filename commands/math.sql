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
		3,
		'math',
		NULL,
		NULL,
		'Does math. For more info, check the documentation for math.js',
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
		0,
		NULL,
		'(async function math (context, ...args) {
	const { response, status } = await sb.Got.instances.Leppunen({
		url: \"math\",
		searchParams: new sb.URLParams()
			.set(\"expr\", args.join(\" \"))
			.toString()
	}).json();
	
	if (status === 200 || status === 503) {
		const string = response.replace(/\\bNaN\\b/g, \"NaM\").replace(/\\btrue\\b/g, \"TRUE LULW\");
		return {
			reply: (context.platform.Name === \"discord\")
				? `\\`${string}\\``
				: string
		};
	}
	else {
		return {
			reply: \"@Leppunen $math failed monkaS\"
		};
	}
})',
		NULL,
		'async (prefix) => {
	return [
		\"Calculates advanced maths. You can use functions, derivatives, integrals, methods, ...\",
		\"Look here for more info: <a href=\'https://mathjs.org/\'>mathjs documentation</a>\",
		\"Arguments are the mathematical expression you want to calculate.\",
		\"\",
		prefix + \"math e^(i*pi) + 1 => 0\",
		prefix + \"math 1+1 => 2\",
		prefix + \"math sin(pi/2) => 1\" 
	];
}'
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function math (context, ...args) {
	const { response, status } = await sb.Got.instances.Leppunen({
		url: \"math\",
		searchParams: new sb.URLParams()
			.set(\"expr\", args.join(\" \"))
			.toString()
	}).json();
	
	if (status === 200 || status === 503) {
		const string = response.replace(/\\bNaN\\b/g, \"NaM\").replace(/\\btrue\\b/g, \"TRUE LULW\");
		return {
			reply: (context.platform.Name === \"discord\")
				? `\\`${string}\\``
				: string
		};
	}
	else {
		return {
			reply: \"@Leppunen $math failed monkaS\"
		};
	}
})'