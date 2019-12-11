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
		0,
		NULL,
		0,
		0,
		0,
		1,
		1,
		0,
		'(async function when (context) {
	const list = sb.VideoLANConnector.videoQueue;
	const current = await sb.VideoLANConnector.currentlyPlayingData();
	if (current === null) {
		return { 
			reply: \"Nothing is currently playing!\"
		};
	}

	const queued = list.filter(i => i.vlcID >= current.vlcID).sort((a, b) => a.vlcID - b.vlcID)
	if (queued.length === 0) {
		return { 
			reply: \"There are no videos queued right now!\"
		};
	}
	
	const userRequest = queued.find(i => i.user === context.user.ID);
	if (!userRequest) {
		return {
			reply: \"You have no video(s) waiting in the queue!\"
		};
	}
	else if (userRequest.vlcID === current.vlcID) {
		return {
			reply: \"Your video request is playing right now!\"
		};
	}


	const status = await sb.VideoLANConnector.status();
	let length = status.length - status.time;

	for (const request of queued.slice(1)) {
		if (request.vlcID === userRequest.vlcID) {
			break;
		}

		length += (request.length || 0);
	}

	const delta = sb.Utils.formatTime(length);
	return {
		reply: `Your request \"${userRequest.name}\" (ID ${userRequest.vlcID}) is playing in ${delta}.`
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function when (context) {
	const list = sb.VideoLANConnector.videoQueue;
	const current = await sb.VideoLANConnector.currentlyPlayingData();
	if (current === null) {
		return { 
			reply: \"Nothing is currently playing!\"
		};
	}

	const queued = list.filter(i => i.vlcID >= current.vlcID).sort((a, b) => a.vlcID - b.vlcID)
	if (queued.length === 0) {
		return { 
			reply: \"There are no videos queued right now!\"
		};
	}
	
	const userRequest = queued.find(i => i.user === context.user.ID);
	if (!userRequest) {
		return {
			reply: \"You have no video(s) waiting in the queue!\"
		};
	}
	else if (userRequest.vlcID === current.vlcID) {
		return {
			reply: \"Your video request is playing right now!\"
		};
	}


	const status = await sb.VideoLANConnector.status();
	let length = status.length - status.time;

	for (const request of queued.slice(1)) {
		if (request.vlcID === userRequest.vlcID) {
			break;
		}

		length += (request.length || 0);
	}

	const delta = sb.Utils.formatTime(length);
	return {
		reply: `Your request \"${userRequest.name}\" (ID ${userRequest.vlcID}) is playing in ${delta}.`
	};
})'