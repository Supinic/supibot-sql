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
		3,
		'math',
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
		'(async function math (context, ...args) {
	const data = await sb.Got.instances.Leppunen({
		url: \"math\",
		searchParams: new sb.URLParams()
			.set(\"expr\", args.join(\" \"))
			.toString()
	}).json();
	
	return {
		reply: (data.status === 200 || data.status === 503)
			? data.response.replace(/\\bNaN\\b/g, \"NaM\").replace(/\\btrue\\b/g, \"TRUE LULW\")
			: \"Oh shit @Leppunen pajaS\"
	};
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
	const data = await sb.Got.instances.Leppunen({
		url: \"math\",
		searchParams: new sb.URLParams()
			.set(\"expr\", args.join(\" \"))
			.toString()
	}).json();
	
	return {
		reply: (data.status === 200 || data.status === 503)
			? data.response.replace(/\\bNaN\\b/g, \"NaM\").replace(/\\btrue\\b/g, \"TRUE LULW\")
			: \"Oh shit @Leppunen pajaS\"
	};
})'