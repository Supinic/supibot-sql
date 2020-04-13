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
		126,
		'botsubs',
		NULL,
		NULL,
		'Checks the channels supibot is currently subscribed to on Twitch.',
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
		0,
		NULL,
		'(async function botSubs () {
	const controller = sb.Platform.get(\"twitch\").controller;
	const sampleEmotes = Object.entries(controller.availableEmotes)
 		.filter(([id]) => Number(id) > 0)
		.map(([id, emotes]) => sb.Utils.randArray(emotes).id);	
	
	const channelData = await sb.Got({
		url: \"https://api.twitchemotes.com/api/v4/emotes\",
		searchParams: \"id=\" + sampleEmotes.join(\",\")
	}).json();

	const channelList = channelData.filter(i => i.channel_name).sort((a, b) => a.channel_name.localeCompare(b.channel_name));
	const channels = channelList.map(i => i.channel_name).join(\", \");
	const emotes = channelList.map(i => i.code).join(\" \");

	return {
		reply: \"Supibot is currently subbed to: \" + channels + \" \" + emotes
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function botSubs () {
	const controller = sb.Platform.get(\"twitch\").controller;
	const sampleEmotes = Object.entries(controller.availableEmotes)
 		.filter(([id]) => Number(id) > 0)
		.map(([id, emotes]) => sb.Utils.randArray(emotes).id);	
	
	const channelData = await sb.Got({
		url: \"https://api.twitchemotes.com/api/v4/emotes\",
		searchParams: \"id=\" + sampleEmotes.join(\",\")
	}).json();

	const channelList = channelData.filter(i => i.channel_name).sort((a, b) => a.channel_name.localeCompare(b.channel_name));
	const channels = channelList.map(i => i.channel_name).join(\", \");
	const emotes = channelList.map(i => i.code).join(\" \");

	return {
		reply: \"Supibot is currently subbed to: \" + channels + \" \" + emotes
	};
})'