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
		121,
		'kiss',
		NULL,
		'opt-out,pipe',
		'Kisses target user.',
		10000,
		NULL,
		'({
	emojis: [\"👩‍❤️‍💋‍👨\", \"💋\", \"😗\", \"👩‍❤️‍💋‍👨\", \"😙\", \"😚\", \"😽\", \"💋😳\", \"👨‍❤️‍💋‍👨\"]
})',
		'(async function kiss (context, user, emote) {
	if (!user || user.toLowerCase() === context.user.Name) {
		return {
			reply: \"You can\'t really kiss yourself 😕\"
		};
	}
	else if (user === sb.Config.get(\"SELF\")) {
		return {
			reply: \"😊\"
		};
	}
	else {
		const string = (emote)
			? emote + \" 💋\"
			: sb.Utils.randArray(this.staticData.emojis);

		return { 
			reply: `${context.user.Name} kisses ${user} ${string}` 
		};
	}
})',
		NULL
	)