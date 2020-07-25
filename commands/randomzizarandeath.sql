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
		201,
		'randomzizarandeath',
		'[\"rzd\"]',
		'mention,pipe',
		'Posts a random video with Zizaran dying in Path of Exile.',
		30000,
		NULL,
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
		'supinic/supibot-sql'
	)