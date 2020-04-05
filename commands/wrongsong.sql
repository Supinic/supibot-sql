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
		167,
		'wrongsong',
		'[\"ws\"]',
		'If you have requested at least one song, this command is going to skip the first one. Use when you accidentally requested something you didn\'t mean to.',
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
		NULL,
		'(async function wrongSong (context, target) {
	const targetID = Number(target) || null;
	const userRequest = await sb.Query.getRecordset(rs => rs
		.select(\"Link\", \"VLC_ID\", \"Status\")
		.select(\"Video_Type.Link_Prefix AS Prefix\")
		.from(\"chat_data\", \"Song_Request\")
		.join({
			toDatabase: \"data\",
			toTable: \"Video_Type\",
			on: \"Video_Type.ID = Song_Request.Video_Type\"
		})
		.where({ condition: Boolean(targetID) }, \"Song_Request.ID = %n\", targetID)
		.where(\"User_Alias = %n\", context.user.ID)
		.where(\"Status IN %s+\", [\"Current\", \"Queued\"])
		.orderBy(\"Song_Request.ID ASC\")
		.limit(1)
		.single()
	);

	if (!userRequest) {
		return {
			reply: (target)
				? \"Target video ID was not found, or it wasn\'t requested by you!\"
				: \"You don\'t currently have any videos in the playlist!\"
		}
	}

	let action = \"\";
	if (userRequest.Status === \"Current\") {
		action = \"skipped\";
		await sb.VideoLANConnector.client.playlistNext();
	}
	else if (userRequest.Status === \"Queued\") {
		action = \"deleted from the playlist\";
		await sb.VideoLANConnector.client.playlistDelete(userRequest.VLC_ID);
	}

	const char = sb.Config.get(\"VIDEO_TYPE_REPLACE_PREFIX\");
	const link = userRequest.Prefix.replace(char, userRequest.Link);
	const linkData = await sb.Utils.linkParser.fetchData(link);

	return {
		reply: `Your request \"${linkData.name}\" (ID ${userRequest.VLC_ID}) has been successfully ${action}.`
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function wrongSong (context, target) {
	const targetID = Number(target) || null;
	const userRequest = await sb.Query.getRecordset(rs => rs
		.select(\"Link\", \"VLC_ID\", \"Status\")
		.select(\"Video_Type.Link_Prefix AS Prefix\")
		.from(\"chat_data\", \"Song_Request\")
		.join({
			toDatabase: \"data\",
			toTable: \"Video_Type\",
			on: \"Video_Type.ID = Song_Request.Video_Type\"
		})
		.where({ condition: Boolean(targetID) }, \"Song_Request.ID = %n\", targetID)
		.where(\"User_Alias = %n\", context.user.ID)
		.where(\"Status IN %s+\", [\"Current\", \"Queued\"])
		.orderBy(\"Song_Request.ID ASC\")
		.limit(1)
		.single()
	);

	if (!userRequest) {
		return {
			reply: (target)
				? \"Target video ID was not found, or it wasn\'t requested by you!\"
				: \"You don\'t currently have any videos in the playlist!\"
		}
	}

	let action = \"\";
	if (userRequest.Status === \"Current\") {
		action = \"skipped\";
		await sb.VideoLANConnector.client.playlistNext();
	}
	else if (userRequest.Status === \"Queued\") {
		action = \"deleted from the playlist\";
		await sb.VideoLANConnector.client.playlistDelete(userRequest.VLC_ID);
	}

	const char = sb.Config.get(\"VIDEO_TYPE_REPLACE_PREFIX\");
	const link = userRequest.Prefix.replace(char, userRequest.Link);
	const linkData = await sb.Utils.linkParser.fetchData(link);

	return {
		reply: `Your request \"${linkData.name}\" (ID ${userRequest.VLC_ID}) has been successfully ${action}.`
	};
})'