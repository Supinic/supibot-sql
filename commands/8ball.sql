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
		133,
		'8ball',
		NULL,
		'ping,pipe',
		'Checks your question against the fortune-telling 8-ball.',
		30000,
		NULL,
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
		'async (prefix, values) => {
	const { responses } = values.getStaticData();
	const list = responses.map(i => `<li>${i}</li>`).join(\"\");

	return [
		\"Consult the 8-ball for your inquiry!\",
		\"\",

		`<code>${prefix}8ball Is this command cool?</code>`,
		sb.Utils.randArray(responses),
		\"\",

		\"List of responses:\",
		`<ul>${list}</ul>`
	];
}
'
	)