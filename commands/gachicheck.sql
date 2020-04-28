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
		47,
		'gachicheck',
		'[\"gc\"]',
		NULL,
		'Checks if a given gachi link exists in the database, if not, adds it to the todo list to be processed later.',
		2500,
		0,
		0,
		1,
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
	limit: 100
})',
		'(async function gachiCheck (context, ...args) {
	if (args.length === 0) {
		return {
			reply: \"No input provided!\",
			cooldown: { length: 2500 }
		};
	}

	let updateExisting = true;
	const links = [];
	if (args[0] === \"playlist\") {
		args.shift();
		const playlistID = args.shift();
		if (!playlistID) {
			return {
				success: false,
				reply: `No playlist ID provided!`
			};
		}

		const { amount, limit, reason, result, success } = await sb.Utils.fetchYoutubePlaylist({
			playlistID,
			key: sb.Config.get(\"API_GOOGLE_YOUTUBE\"),
			limit: this.staticData.limit,
			limitAction: \"return\"
		});

		console.log( { amount, limit, reason, result, success } );

		if (!success) {
			if (reason === \"limit-exceeded\") {
				return {
					success: false,
					reply: `Playlist has too many videos! ${amount} videos fetched, limit is ${limit}.`
				};
			}
			else {
				return {
					success: false,
					reply: `Could not fetch the playlist! Reason: ${reason}`
				};
			}
		}
		else {
			updateExisting = false;
			const items = result.map(i => ({
				link: i.ID,
				type: \"youtube\"
			}));

			links.push(...items);
		}
	}
	else {
		for (const word of args) {
			const type = sb.Utils.linkParser.autoRecognize(word);
			if (type) {
				links.push({
					type,
					link: sb.Utils.linkParser.parseLink(word)
				});
			}
		}
	}

	if (links.length === 0) {
		return {
			reply: \"No valid links provided!\",
			cooldown: { length: 2500 }
		};
	}

	const trackToLink = (id) => (!context.channel || context.channel.Links_Allowed)
		? `https://supinic.com/track/detail/${id}`
		: `track list ID ${id}`;

	if (!this.data.typeMap) {
		const typeData = await sb.Query.getRecordset(rs => rs
			.select(\"ID\", \"Parser_Name\")
			.from(\"data\", \"Video_Type\")
			.where(\"Parser_Name IS NOT NULL\"));

		this.data.typeMap = Object.fromEntries(typeData.map(i => [i.Parser_Name, i.ID]));
	}

	const results = [];
	for (const { link, type } of links) {
		const check = await sb.Query.getRecordset(rs => rs
			.select(\"ID\")
			.from(\"music\", \"Track\")
			.where(\"Link = %s\", link)
			.single()
		);

		if (check) {
			const tagData = (await sb.Query.getRecordset(rs => rs
				.select(\"Tag.Name AS Tag_Name\")
				.from(\"music\", \"Track_Tag\")
				.join(\"music\", {
					raw: \"music.Tag ON Tag.ID = Track_Tag.Tag\"
				})
				.where(\"Track_Tag.Track = %n\", check.ID)
				.flat(\"Tag_Name\")
			));

			const tags = tagData.join(\", \");
			const row = await sb.Query.getRow(\"music\", \"Track\");
			await row.load(check.ID);

			let addendum = \"\";
			if (updateExisting) {
				const videoData = await sb.Utils.linkParser.fetchData(link, type);

				if (row.values.Available && videoData === null) {
					row.values.Available = false;
				}
				else if (row.values.Available && videoData !== null) {
					row.values.Available = true;
				}

				if (row.values.Available !== row.originalValues.Available) {
					addendum = `Track updated: ${row.values.Available ? \"now\" : \"no longer\"} available!`;
					await row.save();
				}
			}

			results.push({
				link,
				existing: true,
				ID: check.ID,
				formatted: sb.Utils.tag.trim`
					Link is in the list already:
					${trackToLink(check.ID)}
					with tags: ${tags}.
					${addendum}`
			});
		}
		else {
			const tag = { todo: 20 };
			const videoData = await sb.Utils.linkParser.fetchData(link, type);
			const row = await sb.Query.getRow(\"music\", \"Track\");

			row.setValues({
				Link: link,
				Name: (videoData && videoData.name) || null,
				Added_By: context.user.ID,
				Video_Type: this.data.typeMap[type],
				Available: Boolean(videoData),
				Published: (videoData?.created) ? new sb.Date(videoData.created) : null,
				Duration: (videoData && videoData.duration) || null,
				Track_Type: null,
				Notes: videoData?.description ?? null
			});

			const { insertId: trackID } = await row.save();
			const tagRow = await sb.Query.getRow(\"music\", \"Track_Tag\");
			tagRow.setValues({
				Track: trackID,
				Tag: tag.todo,
				Added_By: context.user.ID,
				Notes: JSON.stringify(videoData)
			});

			await tagRow.save();

			if (videoData?.author) {
				let authorID = null;
				const normal = videoData.author.toLowerCase().replace(/\\s+/g, \"_\");
				const authorExists = await sb.Query.getRecordset(rs => rs
					.select(\"ID\")
					.from(\"music\", \"Author\")
					.where(\"Normalized_Name = %s\", normal)
					.single()
				);
				if (authorExists && authorExists.ID) {
					authorID = authorExists.ID;
				}
				else {
					const authorRow = await sb.Query.getRow(\"music\", \"Author\");
					authorRow.setValues({
						Name: videoData.author,
						Normalized_Name: normal,
						Added_By: context.user.ID
					});

					authorID = (await authorRow.save()).insertId;
				}

				const authorRow = await sb.Query.getRow(\"music\", \"Track_Author\");
				authorRow.setValues({
					Track: trackID,
					Author: authorID,
					Role: \"Uploader\",
					Added_By: context.user.ID
				});
				await authorRow.save();
			}

			results.push({
				link,
				existing: false,
				ID: row.values.ID,
				formatted: `Saved as ${trackToLink(row.values.ID)} and marked as TODO.`
			});
		}
	}

	if (results.length === 1) {
		return {
			reply: resuls[0].formatted
		};
	}
	else {
		const summary = results.map(i => `${i.link}\\n${i.formatted}`).join(\"\\n\\n\");
		const pastebinLink = await sb.Pastebin.post(summary);

		return {
			reply: `${results.length} videos processed. Summary: ${pastebinLink}`
		};
	}
})',
		'Supports Youtube, Nicovideo, Bilibili, Soundcloud, VK, Vimeo

$gc <link> => Checks the link, and adds it to the todo list if not found
$gc <link <...description> => Checks the link, and adds it to the todo list if not found, with a custom description

$gc https://youtu.be/OI8gy-AHgJg
$gc https://www.nicovideo.jp/watch/sm6140534 ',
		'async (prefix, commandData) => {
	const { limit } = eval(commandData.Static_Data);

	return [
		\"Checks if a video is already in the gachi list.\",
		\"If it isn\'t, it is added with the Todo tag.\",
		\"\",
	
		`<code>${prefix}gc (link)</code>`,
		\"Check for a single link. If it exists already, it is also checked for availability and updated accordingly.\",
		\"\",

		`<code>${prefix}gc (link1) (link2) ...</code>`,
		\"Checks multiple links in one command. Availability will not be updated.\",

		\"\",

		`<code>${prefix}gc playlist (playlistID)</code>`,
		\"Checks all videos in a single Youtube playlist. Summary will be posted in a Pastebin paste.\",
		`Does not check playlists that have more than <b>${limit}</b> videos.`,
		\"As with multiple videos, availability will also not be checked.\"
	];
}'
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function gachiCheck (context, ...args) {
	if (args.length === 0) {
		return {
			reply: \"No input provided!\",
			cooldown: { length: 2500 }
		};
	}

	let updateExisting = true;
	const links = [];
	if (args[0] === \"playlist\") {
		args.shift();
		const playlistID = args.shift();
		if (!playlistID) {
			return {
				success: false,
				reply: `No playlist ID provided!`
			};
		}

		const { amount, limit, reason, result, success } = await sb.Utils.fetchYoutubePlaylist({
			playlistID,
			key: sb.Config.get(\"API_GOOGLE_YOUTUBE\"),
			limit: this.staticData.limit,
			limitAction: \"return\"
		});

		console.log( { amount, limit, reason, result, success } );

		if (!success) {
			if (reason === \"limit-exceeded\") {
				return {
					success: false,
					reply: `Playlist has too many videos! ${amount} videos fetched, limit is ${limit}.`
				};
			}
			else {
				return {
					success: false,
					reply: `Could not fetch the playlist! Reason: ${reason}`
				};
			}
		}
		else {
			updateExisting = false;
			const items = result.map(i => ({
				link: i.ID,
				type: \"youtube\"
			}));

			links.push(...items);
		}
	}
	else {
		for (const word of args) {
			const type = sb.Utils.linkParser.autoRecognize(word);
			if (type) {
				links.push({
					type,
					link: sb.Utils.linkParser.parseLink(word)
				});
			}
		}
	}

	if (links.length === 0) {
		return {
			reply: \"No valid links provided!\",
			cooldown: { length: 2500 }
		};
	}

	const trackToLink = (id) => (!context.channel || context.channel.Links_Allowed)
		? `https://supinic.com/track/detail/${id}`
		: `track list ID ${id}`;

	if (!this.data.typeMap) {
		const typeData = await sb.Query.getRecordset(rs => rs
			.select(\"ID\", \"Parser_Name\")
			.from(\"data\", \"Video_Type\")
			.where(\"Parser_Name IS NOT NULL\"));

		this.data.typeMap = Object.fromEntries(typeData.map(i => [i.Parser_Name, i.ID]));
	}

	const results = [];
	for (const { link, type } of links) {
		const check = await sb.Query.getRecordset(rs => rs
			.select(\"ID\")
			.from(\"music\", \"Track\")
			.where(\"Link = %s\", link)
			.single()
		);

		if (check) {
			const tagData = (await sb.Query.getRecordset(rs => rs
				.select(\"Tag.Name AS Tag_Name\")
				.from(\"music\", \"Track_Tag\")
				.join(\"music\", {
					raw: \"music.Tag ON Tag.ID = Track_Tag.Tag\"
				})
				.where(\"Track_Tag.Track = %n\", check.ID)
				.flat(\"Tag_Name\")
			));

			const tags = tagData.join(\", \");
			const row = await sb.Query.getRow(\"music\", \"Track\");
			await row.load(check.ID);

			let addendum = \"\";
			if (updateExisting) {
				const videoData = await sb.Utils.linkParser.fetchData(link, type);

				if (row.values.Available && videoData === null) {
					row.values.Available = false;
				}
				else if (row.values.Available && videoData !== null) {
					row.values.Available = true;
				}

				if (row.values.Available !== row.originalValues.Available) {
					addendum = `Track updated: ${row.values.Available ? \"now\" : \"no longer\"} available!`;
					await row.save();
				}
			}

			results.push({
				link,
				existing: true,
				ID: check.ID,
				formatted: sb.Utils.tag.trim`
					Link is in the list already:
					${trackToLink(check.ID)}
					with tags: ${tags}.
					${addendum}`
			});
		}
		else {
			const tag = { todo: 20 };
			const videoData = await sb.Utils.linkParser.fetchData(link, type);
			const row = await sb.Query.getRow(\"music\", \"Track\");

			row.setValues({
				Link: link,
				Name: (videoData && videoData.name) || null,
				Added_By: context.user.ID,
				Video_Type: this.data.typeMap[type],
				Available: Boolean(videoData),
				Published: (videoData?.created) ? new sb.Date(videoData.created) : null,
				Duration: (videoData && videoData.duration) || null,
				Track_Type: null,
				Notes: videoData?.description ?? null
			});

			const { insertId: trackID } = await row.save();
			const tagRow = await sb.Query.getRow(\"music\", \"Track_Tag\");
			tagRow.setValues({
				Track: trackID,
				Tag: tag.todo,
				Added_By: context.user.ID,
				Notes: JSON.stringify(videoData)
			});

			await tagRow.save();

			if (videoData?.author) {
				let authorID = null;
				const normal = videoData.author.toLowerCase().replace(/\\s+/g, \"_\");
				const authorExists = await sb.Query.getRecordset(rs => rs
					.select(\"ID\")
					.from(\"music\", \"Author\")
					.where(\"Normalized_Name = %s\", normal)
					.single()
				);
				if (authorExists && authorExists.ID) {
					authorID = authorExists.ID;
				}
				else {
					const authorRow = await sb.Query.getRow(\"music\", \"Author\");
					authorRow.setValues({
						Name: videoData.author,
						Normalized_Name: normal,
						Added_By: context.user.ID
					});

					authorID = (await authorRow.save()).insertId;
				}

				const authorRow = await sb.Query.getRow(\"music\", \"Track_Author\");
				authorRow.setValues({
					Track: trackID,
					Author: authorID,
					Role: \"Uploader\",
					Added_By: context.user.ID
				});
				await authorRow.save();
			}

			results.push({
				link,
				existing: false,
				ID: row.values.ID,
				formatted: `Saved as ${trackToLink(row.values.ID)} and marked as TODO.`
			});
		}
	}

	if (results.length === 1) {
		return {
			reply: resuls[0].formatted
		};
	}
	else {
		const summary = results.map(i => `${i.link}\\n${i.formatted}`).join(\"\\n\\n\");
		const pastebinLink = await sb.Pastebin.post(summary);

		return {
			reply: `${results.length} videos processed. Summary: ${pastebinLink}`
		};
	}
})'