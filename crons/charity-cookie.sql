INSERT INTO
	`chat_data`.`Cron`
	(
		ID,
		Name,
		Expression,
		Description,
		Code,
		Type,
		Active
	)
VALUES
	(
		2,
		'charity-cookie',
		'0 55 1 * * *',
		'Charity cookie - gives away a random cookie to random person who has the Extra_User_Data record, but has not eaten their cookie today - 5 minutes before the reset',
		'async () => {
	const excludedUsers = [2630, 35532, 2756, 1127];
	
	const data = await sb.Query.getRecordset(rs => rs
		.select(\"Extra_User_Data.User_Alias\", \"Channel\")
		.from(\"chat_data\", \"Extra_User_Data\")
		.join({
			toDatabase: \"chat_data\",
			toTable: \"Message_Meta_User_Alias\",
			on: \"Message_Meta_User_Alias.User_Alias = Extra_User_Data.User_Alias\"
		})
		.join({
			toDatabase: \"chat_data\",
			toTable: \"Channel\",
			on: \"Message_Meta_User_Alias.Channel = Channel.ID\"
		})
		.where(\"Channel.Mode <> %s\", \"Read\")
		.where(\"Extra_User_Data.User_Alias NOT IN %n+\", excludedUsers)
		.where(\"Cookie_Today = %b\", false)
		.where(\"Last_Message_Posted >= DATE_SUB(NOW(), INTERVAL 10 MINUTE)\")
		.orderBy(\"RAND()\")
		.limit(1)
		.single()
	);

	const transaction = await sb.Query.getTransaction();
	const userData = await sb.User.get(data.User_Alias);
	const channelData = sb.Channel.get(data.Channel);
	const cookie = await sb.Command.get(\"cookie\").execute({ user: userData, transaction }, \"automatic cookie by supibot\");

	await transaction.commit();

	sb.Master.send(\"Congratulations \" + userData.Name + \", you have won an automatic cookie! \" + cookie.reply, channelData);
	sb.Master.send(userData.Name + \" just got an automatic cookie in channel \" + channelData.Name, 38);
}',
		'Bot',
		1
	)