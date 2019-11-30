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
		10,
		'randomgachi',
		'[\"rg\"]',
		'Fetches a random gachi track from the gachi list, excluding Bilibili and Nicovideo videos with no Youtube reuploads',
		5000,
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
		'(async function randomGachi (extra, ...args) {
	const prefixRow = await sb.Query.getRow(\"data\", \"Video_Type\");
	await prefixRow.load(1);

	let linkOnly = false;
	for (let i = args.length - 1; i >= 0; i--) {
		const token = args[i];
		if (token === \"linkOnly:true\") {
			linkOnly = true;
			args.splice(i, 1);
		}
	}


	const data = await sb.Query.getRecordset(rs => rs
		.select(\"Track.ID AS TrackID, Track.Name AS TrackName, Track.Link AS TrackLink\")
		.select(\"GROUP_CONCAT(Author.Name SEPARATOR \',\') AS Authors\")
		.from(\"music\", \"Track\")
		.leftJoin({
			toDatabase: \"music\",
			toTable: \"Track_Tag\",
			on: \"Track_Tag.Track = Track.ID\"
		})
		.leftJoin({
			toDatabase: \"music\",
			toTable: \"Track_Author\",
			on: \"Track_Author.Track = Track.ID\"
		})
		.leftJoin({
			toDatabase: \"music\",
			toTable: \"Author\",
			on: \"Author.ID = Track_Author.Author\"
		})
		.where(\"Available = %b\", true)
		.where(\"Track.Video_Type = %n\", 1)
		.where(\"Track_Tag.Tag = %n\", 6)
		.groupBy(\"Track.ID\")
		.orderBy(\"RAND() DESC\")
		.single()
	);
	
	const authorList = (data.Authors || \"(unknown)\").split(\",\");
	const authors = (authorList.length === 1) ? authorList[0] : \"(various)\";
	const supiLink = \"https://supinic.com/track/detail/\" + data.TrackID;

	if (linkOnly) {
		return {
			reply: `https://youtu.be/${data.TrackLink}`
		};
	}
	else {
		return {
			reply: `Here\'s your random gachi: \"${data.TrackName}\" by ${authors} - ${supiLink} gachiGASM`
		};
	}
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function randomGachi (extra, ...args) {
	const prefixRow = await sb.Query.getRow(\"data\", \"Video_Type\");
	await prefixRow.load(1);

	let linkOnly = false;
	for (let i = args.length - 1; i >= 0; i--) {
		const token = args[i];
		if (token === \"linkOnly:true\") {
			linkOnly = true;
			args.splice(i, 1);
		}
	}


	const data = await sb.Query.getRecordset(rs => rs
		.select(\"Track.ID AS TrackID, Track.Name AS TrackName, Track.Link AS TrackLink\")
		.select(\"GROUP_CONCAT(Author.Name SEPARATOR \',\') AS Authors\")
		.from(\"music\", \"Track\")
		.leftJoin({
			toDatabase: \"music\",
			toTable: \"Track_Tag\",
			on: \"Track_Tag.Track = Track.ID\"
		})
		.leftJoin({
			toDatabase: \"music\",
			toTable: \"Track_Author\",
			on: \"Track_Author.Track = Track.ID\"
		})
		.leftJoin({
			toDatabase: \"music\",
			toTable: \"Author\",
			on: \"Author.ID = Track_Author.Author\"
		})
		.where(\"Available = %b\", true)
		.where(\"Track.Video_Type = %n\", 1)
		.where(\"Track_Tag.Tag = %n\", 6)
		.groupBy(\"Track.ID\")
		.orderBy(\"RAND() DESC\")
		.single()
	);
	
	const authorList = (data.Authors || \"(unknown)\").split(\",\");
	const authors = (authorList.length === 1) ? authorList[0] : \"(various)\";
	const supiLink = \"https://supinic.com/track/detail/\" + data.TrackID;

	if (linkOnly) {
		return {
			reply: `https://youtu.be/${data.TrackLink}`
		};
	}
	else {
		return {
			reply: `Here\'s your random gachi: \"${data.TrackName}\" by ${authors} - ${supiLink} gachiGASM`
		};
	}
})'