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
		47,
		'gachicheck',
		'[\"gc\"]',
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
		'(async function gachiCheck (context, ...args) {
	if (args.length === 0) {
		return {
			reply: \"No input provided!\",
			cooldown: { length: 2500 }
		};
	}

	const links = [];
	for (const word of args) {
		if (sb.Utils.linkParser.autoRecognize(word)) {
			links.push(sb.Utils.linkParser.parseLink(word));
		}
	}

	if (links.length === 0) {
		return {
			reply: \"No valid links provided!\",
			cooldown: { length: 2500 }
		};
	}
	else if (links.length > 1) {
		return {
			reply: \"Multiple links detected, cannot proceed! Links: \" + links.join(\", \"),
			cooldown: { length: 2500 }
		};
	}

	const link = links[0];
	const originalLink = link;
	const trackToLink = (id) => (!context.channel || context.channel.Links_Allowed)
		? `https://supinic.com/track/detail/${id}`
		: `track list ID ${id}`;

	if (!this.data.typeMap) {
		const typeData = await sb.Query.getRecordset(rs => rs
			.select(\"ID\", \"Parser_Name\")
			.from(\"data\", \"Video_Type\")
			.where(\"Parser_Name IS NOT NULL\")
		);

		this.data.typeMap = Object.fromEntries(typeData.map(i => [i.Parser_Name, i.ID]));
	}

	const type = sb.Utils.linkParser.autoRecognize(link);
	if (!type) {
		return { reply: \"Unrecognized link type!\" };
	}

	const check = (await sb.Query.getRecordset(rs => rs
		.select(\"ID\")
		.from(\"music\", \"Track\")
		.where(\"Link = %s\", link)
		.single()
	));

	if (check) {
		const tags = (await sb.Query.getRecordset(rs => rs
			.select(\"Tag.Name AS Tag_Name\")
			.from(\"music\", \"Track_Tag\")
			.join(\"music\", {
				raw: \"music.Tag ON Tag.ID = Track_Tag.Tag\"
			})
			.where(\"Track_Tag.Track = %n\", check.ID)
		)).map(i => i.Tag_Name).join(\", \");

		return {
			reply: \"Link is in the list already: \" + trackToLink(check.ID) + \" with tags: \" + tags
		};
	}
	else {
		const tag = { todo: 20 };
		const videoData = await sb.Utils.linkParser.fetchData(originalLink);
		const row = await sb.Query.getRow(\"music\", \"Track\");

		row.setValues({
			Link: link,
			Name: (videoData && videoData.name) || null,
			Added_By: context.user.ID,
			Video_Type: this.data.typeMap[type],
			Available: Boolean(videoData),
			Published: (videoData?.created)
				? new sb.Date(videoData.created)
				: null,
			Duration: (videoData && videoData.duration) || null,
			Track_Type: null,
			Notes: videoData.description || null
		});

		const {insertId: trackID} = await row.save();
		const tagRow = await sb.Query.getRow(\"music\", \"Track_Tag\");
		tagRow.setValues({
			Track: trackID,
			Tag: tag.todo,
			Added_By: context.user.ID,
			Notes: JSON.stringify(videoData)
		});

		await tagRow.save();

		if (videoData.author) {
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

		return {
			reply: \"Saved as \" + trackToLink(row.values.ID) + \" and marked as TODO.\"
		};
	}
})',
		'Supports Youtube, Nicovideo, Bilibili, Soundcloud, VK, Vimeo

$gc <link> => Checks the link, and adds it to the todo list if not found
$gc <link <...description> => Checks the link, and adds it to the todo list if not found, with a custom description

$gc https://youtu.be/OI8gy-AHgJg
$gc https://www.nicovideo.jp/watch/sm6140534 ',
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function gachiCheck (context, ...args) {
	if (args.length === 0) {
		return {
			reply: \"No input provided!\",
			cooldown: { length: 2500 }
		};
	}

	const links = [];
	for (const word of args) {
		if (sb.Utils.linkParser.autoRecognize(word)) {
			links.push(sb.Utils.linkParser.parseLink(word));
		}
	}

	if (links.length === 0) {
		return {
			reply: \"No valid links provided!\",
			cooldown: { length: 2500 }
		};
	}
	else if (links.length > 1) {
		return {
			reply: \"Multiple links detected, cannot proceed! Links: \" + links.join(\", \"),
			cooldown: { length: 2500 }
		};
	}

	const link = links[0];
	const originalLink = link;
	const trackToLink = (id) => (!context.channel || context.channel.Links_Allowed)
		? `https://supinic.com/track/detail/${id}`
		: `track list ID ${id}`;

	if (!this.data.typeMap) {
		const typeData = await sb.Query.getRecordset(rs => rs
			.select(\"ID\", \"Parser_Name\")
			.from(\"data\", \"Video_Type\")
			.where(\"Parser_Name IS NOT NULL\")
		);

		this.data.typeMap = Object.fromEntries(typeData.map(i => [i.Parser_Name, i.ID]));
	}

	const type = sb.Utils.linkParser.autoRecognize(link);
	if (!type) {
		return { reply: \"Unrecognized link type!\" };
	}

	const check = (await sb.Query.getRecordset(rs => rs
		.select(\"ID\")
		.from(\"music\", \"Track\")
		.where(\"Link = %s\", link)
		.single()
	));

	if (check) {
		const tags = (await sb.Query.getRecordset(rs => rs
			.select(\"Tag.Name AS Tag_Name\")
			.from(\"music\", \"Track_Tag\")
			.join(\"music\", {
				raw: \"music.Tag ON Tag.ID = Track_Tag.Tag\"
			})
			.where(\"Track_Tag.Track = %n\", check.ID)
		)).map(i => i.Tag_Name).join(\", \");

		return {
			reply: \"Link is in the list already: \" + trackToLink(check.ID) + \" with tags: \" + tags
		};
	}
	else {
		const tag = { todo: 20 };
		const videoData = await sb.Utils.linkParser.fetchData(originalLink);
		const row = await sb.Query.getRow(\"music\", \"Track\");

		row.setValues({
			Link: link,
			Name: (videoData && videoData.name) || null,
			Added_By: context.user.ID,
			Video_Type: this.data.typeMap[type],
			Available: Boolean(videoData),
			Published: (videoData?.created)
				? new sb.Date(videoData.created)
				: null,
			Duration: (videoData && videoData.duration) || null,
			Track_Type: null,
			Notes: videoData.description || null
		});

		const {insertId: trackID} = await row.save();
		const tagRow = await sb.Query.getRow(\"music\", \"Track_Tag\");
		tagRow.setValues({
			Track: trackID,
			Tag: tag.todo,
			Added_By: context.user.ID,
			Notes: JSON.stringify(videoData)
		});

		await tagRow.save();

		if (videoData.author) {
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

		return {
			reply: \"Saved as \" + trackToLink(row.values.ID) + \" and marked as TODO.\"
		};
	}
})'