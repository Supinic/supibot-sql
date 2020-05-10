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
		Dynamic_Description
	)
VALUES
	(
		127,
		'downloadyoutubecaptions',
		'[\"dytc\", \"dyts\"]',
		'archived,ping,pipe,whitelist',
		'Downloads the subtitles (captions) of a video, posts them in a Pastebin paste and gives you the link.',
		60000,
		'Temporarily disabled',
		NULL,
		'(async function downloadYoutubeCaptions (context, video) {
	if (!video || !video.includes(\"youtu\")) { // @todo - put link parser verification here
		return {
			reply: \"You must provide a valid Youtube link!\"
		};
	}

	const cwd = \"/tmp/\";
	const files = await new Promise((resolve, reject) => {
		sb.Utils.ytdl.getSubs(video, { auto: false, cwd: cwd }, (err, files) => {
			if (err) {
				reject(err);
			}
			else {
				resolve(files);
			}
		});
	});

	if (!files[0]) {
		return { 
			reply: \"That video has no subtitles.\" 
		};
	}

	const fs = require(\"fs\");
	const content = fs.readFileSync(cwd + files[0]);
	const link = await sb.Pastebin.post(content, {
		name: \"Subtitles for \" + video + \" requested by: \" + context.user.Name
	});

	return {
		reply: \"Your subtitles are available for 10 minutes here: \" + link
	};
})',
		NULL
	)