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
		201,
		'randomzizarandeath',
		'[\"rzd\"]',
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
		'(async function randomZizaranDeath () {
	if (!this.data.videoList) {
		const playlistID = \"PLbpExg9_Xax24tS9rNt8IP49VFFaDghAG\";
		const videos = [];
		let pageToken = null;

		do {
			// implement and then use sb.URLParams.prototype.clone here
			const params = new sb.URLParams()
				.set(\"part\", \"snippet\")
				.set(\"maxResults\", 50)
				.set(\"key\", sb.Config.get(\"API_GOOGLE_YOUTUBE\"))
				.set(\"playlistId\", \"PLbpExg9_Xax24tS9rNt8IP49VFFaDghAG\");

			if (pageToken) {
				params.set(\"pageToken\", pageToken);
			}
			
			const playlistData = await sb.Got({
				url: \"https://www.googleapis.com/youtube/v3/playlistItems\",
				searchParams: params.toString()
			}).json();
			
			pageToken = playlistData.nextPageToken;
			videos.push(...playlistData.items.map(i => i.snippet.resourceId.videoId));

		} while (pageToken);

		this.data.videoList = videos;
	}

	const video = sb.Utils.randArray(this.data.videoList);
	return {
		reply: `PepeLaugh 👉 https://youtu.be/${video}`
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function randomZizaranDeath () {
	if (!this.data.videoList) {
		const playlistID = \"PLbpExg9_Xax24tS9rNt8IP49VFFaDghAG\";
		const videos = [];
		let pageToken = null;

		do {
			// implement and then use sb.URLParams.prototype.clone here
			const params = new sb.URLParams()
				.set(\"part\", \"snippet\")
				.set(\"maxResults\", 50)
				.set(\"key\", sb.Config.get(\"API_GOOGLE_YOUTUBE\"))
				.set(\"playlistId\", \"PLbpExg9_Xax24tS9rNt8IP49VFFaDghAG\");

			if (pageToken) {
				params.set(\"pageToken\", pageToken);
			}
			
			const playlistData = await sb.Got({
				url: \"https://www.googleapis.com/youtube/v3/playlistItems\",
				searchParams: params.toString()
			}).json();
			
			pageToken = playlistData.nextPageToken;
			videos.push(...playlistData.items.map(i => i.snippet.resourceId.videoId));

		} while (pageToken);

		this.data.videoList = videos;
	}

	const video = sb.Utils.randArray(this.data.videoList);
	return {
		reply: `PepeLaugh 👉 https://youtu.be/${video}`
	};
})'