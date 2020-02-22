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
		1,
		'Only available in channels with VLC API configured!',
		0,
		0,
		0,
		1,
		1,
		0,
		'(async function when (context) {
	const list = sb.VideoLANConnector.videoQueue;
	const current = await sb.VideoLANConnector.currentlyPlayingData();
	if (!current) {
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

	const userRequests = queued.filter(i => i.user === context.user.ID);
	if (userRequests.length === 0) {
		return {
			reply: \"You have no video(s) waiting in the queue!\"
		};
	}

	if (userRequests[0].vlcID === current.vlcID && userRequests.length === 1) {
		return {
			reply: `Your request ${userRequests[0].name} is playing right now! You don\'t have any other videos in the queue.`
		};
	}

	let prepend = \"\";
	let userRequest = userRequests[0];
	if (userRequest.vlcID === current.vlcID) {
		prepend = `Your request \"${userRequests[0].name}\" is playing right now!`;
		userRequest = userRequests[1];
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
	const bridge = (prepend) ? \"Then,\" : \"Your next video\";

	return {
		reply: `${prepend} ${bridge} \"${userRequest.name}\" is playing in ${delta}.`
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function when (context) {
	const list = sb.VideoLANConnector.videoQueue;
	const current = await sb.VideoLANConnector.currentlyPlayingData();
	if (!current) {
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

	const userRequests = queued.filter(i => i.user === context.user.ID);
	if (userRequests.length === 0) {
		return {
			reply: \"You have no video(s) waiting in the queue!\"
		};
	}

	if (userRequests[0].vlcID === current.vlcID && userRequests.length === 1) {
		return {
			reply: `Your request ${userRequests[0].name} is playing right now! You don\'t have any other videos in the queue.`
		};
	}

	let prepend = \"\";
	let userRequest = userRequests[0];
	if (userRequest.vlcID === current.vlcID) {
		prepend = `Your request \"${userRequests[0].name}\" is playing right now!`;
		userRequest = userRequests[1];
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
	const bridge = (prepend) ? \"Then,\" : \"Your next video\";

	return {
		reply: `${prepend} ${bridge} \"${userRequest.name}\" is playing in ${delta}.`
	};
})'