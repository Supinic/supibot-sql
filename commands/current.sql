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
		68,
		'current',
		'[\"song\"]',
		NULL,
		'Fetches the current song playing on stream.',
		5000,
		0,
		0,
		0,
		1,
		NULL,
		0,
		0,
		0,
		1,
		1,
		0,
		0,
		'({
	types: [\"current\", \"previous\"]
})',
		'(async function current (context, type) {
	const linkSymbol = sb.Config.get(\"VIDEO_TYPE_REPLACE_PREFIX\");
	const state = sb.Config.get(\"SONG_REQUESTS_STATE\");

	if (state === \"off\") {
		return { reply: \"Song requests are currently turned off.\" };
	}
	else if (state === \"vlc-read\") {
		const item = sb.VideoLANConnector.currentPlaylistItem;
		if (!item) {
			return {
				reply: \"Nothing is currently playing.\"
			};
		}

		let leaf = item;
		while (leaf.type !== \"leaf\" && leaf.children.length > 0) {
			leaf = leaf.children[0];
		}

		return {
			reply: `Currently playing: ${leaf.name}`
		};
	}
	else if (state === \"dubtrack\") {
		return { reply: \"We are on Dubtrack, check ?song for the currently playing song :)\" };
	}
	else if (state === \"cytube\") {
		const playing = sb.Platform.get(\"cytube\").controller.currentlyPlaying;
		if (playing === null) {
			return {
				reply: \"Nothing is currently playing on Cytube.\"
			};
		}

		const media = playing.media;
		const prefix = (await sb.Query.getRecordset(rs => rs
			.select(\"Link_Prefix\")
			.from(\"data\", \"Video_Type\")
			.where(\"Type = %s\", media.type)
			.limit(1)
			.single()
		)).Link_Prefix;

		const requester = playing.user ?? playing.queueby ?? \"(unknown)\";
		const link = prefix.replace(linkSymbol, media.id);
		return {
			reply: `Currently playing on Cytube: ${media.title} ${link} (${media.duration}), queued by ${requester}`
		}
	}

	type = type || \"current\";
	if (!this.staticData.types.includes(type)) {
		return {
			success: false,
			reply: \"Invalid type provided! Supported types: \" + this.staticData.types.join(\", \")
		};
	}

	const playing = await sb.Query.getRecordset(rs => {
		rs.select(\"Name\", \"VLC_ID\", \"Link\", \"User_Alias AS User\")
			.select(\"Video_Type.Link_Prefix AS Prefix\")
			.from(\"chat_data\", \"Song_Request\")
			.join({
				toDatabase: \"data\",
				toTable: \"Video_Type\",
				on: \"Video_Type.ID = Song_Request.Video_type\"
			})
			.limit(1)
			.single();

		if (type === \"previous\") {
			rs.where(\"Status = %s\", \"Inactive\");
			rs.orderBy(\"Song_Request.ID DESC\");
		}
		else if (type === \"current\") {
			rs.where(\"Status = %s\", \"Current\");
		}

		return rs;
	});

	if (playing) {
		const link = playing.Prefix.replace(linkSymbol, playing.Link);
		const userData = await sb.User.get(playing.User);
		const { length, time } = await sb.VideoLANConnector.status();

		return {
			reply: sb.Utils.tag.trim `
				Currently playing: ${playing.Name}
				(ID ${playing.VLC_ID})
				-
				requested by ${userData.Name}.
				Current position: ${time}/${length}s.
				${link}
			`
		};
	}
	else {
		return {
			reply: \"No video is currently being played.\"
		};
	}
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function current (context, type) {
	const linkSymbol = sb.Config.get(\"VIDEO_TYPE_REPLACE_PREFIX\");
	const state = sb.Config.get(\"SONG_REQUESTS_STATE\");

	if (state === \"off\") {
		return { reply: \"Song requests are currently turned off.\" };
	}
	else if (state === \"vlc-read\") {
		const item = sb.VideoLANConnector.currentPlaylistItem;
		if (!item) {
			return {
				reply: \"Nothing is currently playing.\"
			};
		}

		let leaf = item;
		while (leaf.type !== \"leaf\" && leaf.children.length > 0) {
			leaf = leaf.children[0];
		}

		return {
			reply: `Currently playing: ${leaf.name}`
		};
	}
	else if (state === \"dubtrack\") {
		return { reply: \"We are on Dubtrack, check ?song for the currently playing song :)\" };
	}
	else if (state === \"cytube\") {
		const playing = sb.Platform.get(\"cytube\").controller.currentlyPlaying;
		if (playing === null) {
			return {
				reply: \"Nothing is currently playing on Cytube.\"
			};
		}

		const media = playing.media;
		const prefix = (await sb.Query.getRecordset(rs => rs
			.select(\"Link_Prefix\")
			.from(\"data\", \"Video_Type\")
			.where(\"Type = %s\", media.type)
			.limit(1)
			.single()
		)).Link_Prefix;

		const requester = playing.user ?? playing.queueby ?? \"(unknown)\";
		const link = prefix.replace(linkSymbol, media.id);
		return {
			reply: `Currently playing on Cytube: ${media.title} ${link} (${media.duration}), queued by ${requester}`
		}
	}

	type = type || \"current\";
	if (!this.staticData.types.includes(type)) {
		return {
			success: false,
			reply: \"Invalid type provided! Supported types: \" + this.staticData.types.join(\", \")
		};
	}

	const playing = await sb.Query.getRecordset(rs => {
		rs.select(\"Name\", \"VLC_ID\", \"Link\", \"User_Alias AS User\")
			.select(\"Video_Type.Link_Prefix AS Prefix\")
			.from(\"chat_data\", \"Song_Request\")
			.join({
				toDatabase: \"data\",
				toTable: \"Video_Type\",
				on: \"Video_Type.ID = Song_Request.Video_type\"
			})
			.limit(1)
			.single();

		if (type === \"previous\") {
			rs.where(\"Status = %s\", \"Inactive\");
			rs.orderBy(\"Song_Request.ID DESC\");
		}
		else if (type === \"current\") {
			rs.where(\"Status = %s\", \"Current\");
		}

		return rs;
	});

	if (playing) {
		const link = playing.Prefix.replace(linkSymbol, playing.Link);
		const userData = await sb.User.get(playing.User);
		const { length, time } = await sb.VideoLANConnector.status();

		return {
			reply: sb.Utils.tag.trim `
				Currently playing: ${playing.Name}
				(ID ${playing.VLC_ID})
				-
				requested by ${userData.Name}.
				Current position: ${time}/${length}s.
				${link}
			`
		};
	}
	else {
		return {
			reply: \"No video is currently being played.\"
		};
	}
})'