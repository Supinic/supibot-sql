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
		151,
		'countlinesofcode',
		'[\"cloc\"]',
		'Counts the lines of supibot\'s code.',
		60000,
		0,
		1,
		0,
		0,
		NULL,
		0,
		0,
		0,
		1,
		1,
		0,
		NULL,
		'async () => {
	const files = sb.Config.get(\"SUPIBOT_FILES\");
	const readFile = require(\"util\").promisify(require(\"fs\").readFile);

	let backendLength = 0;
	let backendLines = 0;
	(await Promise.all(files.map(file => (async () => {
		const arr = Array.from(await readFile(file));
		backendLength += arr.length;
		backendLines += arr.filter(i => i === 10).length + 1;
	})())));

	let commandLength = 0;
	let commandLines = 0;
	for (const command of sb.Command.data) {
		const codeString = command.Code.toString();
		commandLength += codeString.length;
		commandLines += Array.from(codeString).filter(i => i.charCodeAt(0) === 10).length + 1;
	};	

	return { 
		reply: `I consist of ${commandLines + backendLines} lines of code (backend: ${backendLines}, commands: ${commandLines}); for a total of ${backendLength + commandLength} characters.`
	};
}',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async () => {
	const files = sb.Config.get(\"SUPIBOT_FILES\");
	const readFile = require(\"util\").promisify(require(\"fs\").readFile);

	let backendLength = 0;
	let backendLines = 0;
	(await Promise.all(files.map(file => (async () => {
		const arr = Array.from(await readFile(file));
		backendLength += arr.length;
		backendLines += arr.filter(i => i === 10).length + 1;
	})())));

	let commandLength = 0;
	let commandLines = 0;
	for (const command of sb.Command.data) {
		const codeString = command.Code.toString();
		commandLength += codeString.length;
		commandLines += Array.from(codeString).filter(i => i.charCodeAt(0) === 10).length + 1;
	};	

	return { 
		reply: `I consist of ${commandLines + backendLines} lines of code (backend: ${backendLines}, commands: ${commandLines}); for a total of ${backendLength + commandLength} characters.`
	};
}'