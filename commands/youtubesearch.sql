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
		215,
		'youtubesearch',
		'[\"ys\"]',
		NULL,
		'Searches Youtube for video(s) with your query. Respects safe search for each platform.',
		15000,
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
		'(async function youtubeSearch (context, ...args) {
	const query = args.join(\" \");
	if (!query) {
		return {
			success: false,
			reply: `No query provided!`
		};
	}

	let safeSearch = \"strict\";
	if (context.platform.name === \"discord\") {
		if (!context.channel || context.channel.NSFW) {
			safeSearch = \"off\";
		}
		else {
			safeSearch = \"moderate\";
		}
	}

	const list = await sb.Utils.searchYoutube(
		query,
		sb.Config.get(\"API_GOOGLE_YOUTUBE\"),
		{ 
			safeSearch
		}
	);
	
	if (list.length === 0) {
		return {
			success: false,
			reply: \"No videos found for that query!\"
		};
	}
	else {
		const [video] = list;
		return {
			reply: `https://youtu.be/${video.ID}`
		};
	}
})',
		NULL,
		NULL
	)