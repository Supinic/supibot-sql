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
		133,
		'8ball',
		NULL,
		'Checks your question against the fortune-telling 8-ball.',
		30000,
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
	responses: [
		\"😃 It is certain.\",
		\"😃 It is decidedly so.\",
		\"😃 Without a doubt.\",
		\"😃 Yes - definitely.\",
		\"😃 You may rely on it.\",
		\"😃 As I see it, yes.\",
		\"😃 Most likely.\",
		\"😃 Outlook good.\",
		\"😃 Yes.\",
		\"😃 Signs point to yes.\",
		
		\"😐 Reply hazy, try again.\",
		\"😐 Ask again later.\",
		\"😐 Better not tell you now.\",
		\"😐 Cannot predict now.\",
		\"😐 Concentrate and ask again.\",
		
		\"😦 Don\'t count on it.\",
		\"😦 My reply is no.\",
		\"😦 My sources say no.\",
		\"😦 Outlook not so good.\",
		\"😦 Very doubtful.\"
	]
})',
		'(async function _8ball () {
	return {
		reply: sb.Utils.randArray(this.staticData.responses)
	};
})',
		NULL,
		'async (prefix) => [
	\"Consult the 8-ball for your question!\",
	\"\",

	`<code>${prefix}8ball Is this command cool?</code>`,
	sb.Utils.randArray(sb.Config.get(\"8_BALL_RESPONSES\"))
]	'
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function _8ball () {
	return {
		reply: sb.Utils.randArray(this.staticData.responses)
	};
})'