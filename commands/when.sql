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
		187,
		'when',
		NULL,
		'Tells you when your command is going to be played next, approximately.',
		15000,
		0,
		0,
		0,
		1,
		'Only available in channels with VLC API configured!',
		0,
		0,
		0,
		1,
		1,
		0,
		NULL,
		'(async function when (context) {
	if (sb.Config.get(\"SONG_REQUESTS_STATE\") !== \"vlc\") {
		return {
			reply: \"Song requests are currently off or not in VLC!\"
		};
	}

	const prefixSymbol = sb.Config.get(\"VIDEO_TYPE_REPLACE_PREFIX\");
	const queue = await sb.Query.getRecordset(rs => rs
		.select(\"Length\", \"Link\", \"Name\", \"Status\", \"User_Alias\")
		.select(\"Video_Type.Link_Prefix AS Prefix\")
		.from(\"chat_data\", \"Song_Request\")
		.join({
			toDatabase: \"data\",
			toTable: \"Video_Type\",
			on: \"Video_Type.ID = Song_Request.Video_Type\"
		})
		.where(\"Status IN %s+\", [\"Current\", \"Queued\"])
	);
	const personal = queue.filter(i => i.User_Alias === context.user.ID);

	if (queue.length === 0) {
		return {
			reply: \"The playlist is currently empty.\"
		};
	}
	else if (personal.length === 0) {
		return {
			reply: \"You have no video(s) queued up.\"
		};
	}

	let prepend = \"\";
	let target = personal[0];
	let timeRemaining = 0;

	if (target.Status === \"Current\") {		
		if (personal.length === 1) {
			return {
				reply: `Your request \"${target.Name}\" is playing right now. You don\'t have any other videos in the queue.`
			};
		}
		else {
			prepend = `Your request \"${target.Name}\" is playing right now.`;
			target = personal[1];
		}
	}

	let index = 0;
	let loopItem = queue[index];
	while (loopItem !== target && index < queue.length) {
		timeRemaining += loopItem.Length;
		loopItem = queue[++index];
	}

	const status = await sb.VideoLANConnector.status();
	if (status) {
		timeRemaining -= status.time;
	}

	const delta = sb.Utils.formatTime(timeRemaining);
	const bridge = (prepend) ? \"Then,\" : \"Your next video\";

	return {
		reply: `${prepend} ${bridge} \"${target.Name}\" is playing in ${delta}.`
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function when (context) {
	if (sb.Config.get(\"SONG_REQUESTS_STATE\") !== \"vlc\") {
		return {
			reply: \"Song requests are currently off or not in VLC!\"
		};
	}

	const prefixSymbol = sb.Config.get(\"VIDEO_TYPE_REPLACE_PREFIX\");
	const queue = await sb.Query.getRecordset(rs => rs
		.select(\"Length\", \"Link\", \"Name\", \"Status\", \"User_Alias\")
		.select(\"Video_Type.Link_Prefix AS Prefix\")
		.from(\"chat_data\", \"Song_Request\")
		.join({
			toDatabase: \"data\",
			toTable: \"Video_Type\",
			on: \"Video_Type.ID = Song_Request.Video_Type\"
		})
		.where(\"Status IN %s+\", [\"Current\", \"Queued\"])
	);
	const personal = queue.filter(i => i.User_Alias === context.user.ID);

	if (queue.length === 0) {
		return {
			reply: \"The playlist is currently empty.\"
		};
	}
	else if (personal.length === 0) {
		return {
			reply: \"You have no video(s) queued up.\"
		};
	}

	let prepend = \"\";
	let target = personal[0];
	let timeRemaining = 0;

	if (target.Status === \"Current\") {		
		if (personal.length === 1) {
			return {
				reply: `Your request \"${target.Name}\" is playing right now. You don\'t have any other videos in the queue.`
			};
		}
		else {
			prepend = `Your request \"${target.Name}\" is playing right now.`;
			target = personal[1];
		}
	}

	let index = 0;
	let loopItem = queue[index];
	while (loopItem !== target && index < queue.length) {
		timeRemaining += loopItem.Length;
		loopItem = queue[++index];
	}

	const status = await sb.VideoLANConnector.status();
	if (status) {
		timeRemaining -= status.time;
	}

	const delta = sb.Utils.formatTime(timeRemaining);
	const bridge = (prepend) ? \"Then,\" : \"Your next video\";

	return {
		reply: `${prepend} ${bridge} \"${target.Name}\" is playing in ${delta}.`
	};
})'