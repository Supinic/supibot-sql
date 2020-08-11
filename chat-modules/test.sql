INSERT INTO
	`chat_data`.`Chat_Module`
	(
		ID,
		Name,
		Events,
		Description,
		Code
	)
VALUES
	(
		1,
		'test',
		'[\"message\"]',
		'Test',
		'(async function (context) {
	// context: { channel, event, message, specificArguments }

	if (context.message === \"Kappa\") {
		await context.channel.send(\"Keepo\");
		console.log({ context: context, this: this });
	}
})'
	)