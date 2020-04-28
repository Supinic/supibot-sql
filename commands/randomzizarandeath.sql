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
		201,
		'randomzizarandeath',
		'[\"rzd\"]',
		NULL,
		'Posts a random video with Zizaran dying in Path of Exile.',
		30000,
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
		'({
	playlist: \"PLbpExg9_Xax24tS9rNt8IP49VFFaDghAG\"
})',
		'(async function randomZizaranDeath () {
	if (!this.data.videoList) {
		const { result, reason, success } = await sb.Utils.fetchYoutubePlaylist({
			key: sb.Config.get(\"API_GOOGLE_YOUTUBE\"),
   			playlistID: this.staticData.playlist
		});

		if (!success) {
			return {
				success,
				reply: `Playlist could not be fetched! Reason: ${reason}`
			};
		}
		else {
			this.data.videoList = result;
		}
	}

	const video = sb.Utils.randArray(this.data.videoList);
	return {
		reply: `PepeLaugh 👉 https://youtu.be/${video.ID}`
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function randomZizaranDeath () {
	if (!this.data.videoList) {
		const { result, reason, success } = await sb.Utils.fetchYoutubePlaylist({
			key: sb.Config.get(\"API_GOOGLE_YOUTUBE\"),
   			playlistID: this.staticData.playlist
		});

		if (!success) {
			return {
				success,
				reply: `Playlist could not be fetched! Reason: ${reason}`
			};
		}
		else {
			this.data.videoList = result;
		}
	}

	const video = sb.Utils.randArray(this.data.videoList);
	return {
		reply: `PepeLaugh 👉 https://youtu.be/${video.ID}`
	};
})'