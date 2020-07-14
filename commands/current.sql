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
		Dynamic_Description,
		Source
	)
VALUES
	(
		68,
		'current',
		'[\"song\"]',
		'ping,pipe,whitelist',
		'Fetches the current song playing on stream.',
		5000,
		NULL,
		'({
	types: [\"current\", \"previous\"]
})',
		'(async function current (context, ...args) {
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

	let linkOnly = false;
	for (let i = args.length - 1; i >= 0; i--) {
		const token = args[i];
		if (token.startsWith(\"linkOnly\")) {
			linkOnly = token.split(\":\")[1] === \"true\";
			args.splice(i, 1);
		}
	}

	const type = args.shift() ?? \"current\";
	if (!this.staticData.types.includes(type)) {
		return {
			success: false,
			reply: \"Invalid type provided! Supported types: \" + this.staticData.types.join(\", \")
		};
	}

	let includePosition = false;
	let introductionString = null;

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
			introductionString = \"Previously played:\";
			rs.where(\"Status = %s\", \"Inactive\");
			rs.orderBy(\"Song_Request.ID DESC\");
		}
		else if (type === \"current\") {
			includePosition = true;
			introductionString = \"Currently playing:\";
			rs.where(\"Status = %s\", \"Current\");
		}

		return rs;
	});

	if (playing) {
		const link = playing.Prefix.replace(linkSymbol, playing.Link);
		if (linkOnly) {
			return {
				reply: link
			};
		}		
		
		const userData = await sb.User.get(playing.User);
		const { length, time } = await sb.VideoLANConnector.status();
		const position = (includePosition)
			? `Current position: ${time}/${length}s.`
			: \"\";
		const pauseString = (sb.Config.get(\"SONG_REQUESTS_VLC_PAUSED\"))
			? \"The song request is paused at the moment.\"
			: \"\";

		return {
			reply: sb.Utils.tag.trim `
				${introductionString}
				${playing.Name}
				(ID ${playing.VLC_ID})
				-
				requested by ${userData.Name}.
				${position}
				${link}
				${pauseString}
			`
		};
	}
	else {
		return {
			reply: (linkOnly)
				? null
				: \"No video is currently being played.\"
		};
	}
})',
		NULL,
		'supinic/supibot-sql'
	)