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
		10,
		'randomgachi',
		'[\"rg\"]',
		'link-only,mention,pipe',
		'Fetches a random gachi track from the gachi list, excluding Bilibili and Nicovideo videos with no Youtube reuploads',
		5000,
		NULL,
		NULL,
		'(async function randomGachi (context, ...args) {
	const prefixRow = await sb.Query.getRow(\"data\", \"Video_Type\");
	await prefixRow.load(1);

	let userFavourites = null;
	const favRegex = /^fav(ou?rite)?/;

	for (let i = args.length - 1; i >= 0; i--) {
		const token = args[i];
		if (favRegex.test(token)) {
			const name = token.split(\":\")[1];
			if (name) {
				userFavourites = await sb.User.get(name);
				if (!userFavourites) {
					return {
						success: false,
						link: null,
						reply: `User doesn\'t exist!`
					};
				}
			}
			else {
				userFavourites = context.user;
			}
		}
	}

	const data = await sb.Query.getRecordset(rs => {
		rs.select(\"Track.ID AS TrackID, Track.Name AS TrackName, Track.Link AS TrackLink\")
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
			.single();

		if (userFavourites) {
			rs.where(\"User_Favourite.User_Alias = %n\", userFavourites.ID)
				.where(\"User_Favourite.Active = %b\", true)
				.join({
					toTable: \"User_Favourite\",
					on: \"User_Favourite.Track = Track.ID\"
				});
		}

		return rs;
	});
	if (!data) {
		return {
			success: false,
			link: null,
			reply: `No available YouTube tracks found for given combination of parameters!`
		};
	}

	const authorList = (data.Authors || \"(unknown)\").split(\",\");
	const authors = (authorList.length === 1) ? authorList[0] : \"(various)\";
	const supiLink = \"https://supinic.com/track/detail/\" + data.TrackID;

	return {
		link: `https://youtu.be/${data.TrackLink}`,
		reply: `Here\'s your random gachi: \"${data.TrackName}\" by ${authors} - ${supiLink} gachiGASM`
	};
})',
		'async (prefix) => {https://supinic.com
	return [
		`Returns a random gachimuchi track from the <a href=\"/track/gachi/list\">track list</a>.`,
		\"\",
		
		`<code>${prefix}rg</code>`,
		\"No arguments - any random track\",
		\"\",

		`<code>${prefix}rg favourite</code>`,
		\"If you have marked any tracks as your favourites on the website, this will make the command choose only from your favourites.\",
		\"\",

		`<code>${prefix}rg favourite:(user)</code>`,
		\"Same as above, but for any other user you choose\",
		\"\",

		`<code>${prefix}rg linkOnly:true</code>`,
		\"Will only input the link, with no other text. Useful for piping.\",
		\"<b>Note:</b>When you pipe this command, <code>linkOnly</code> is used by default.\"		
	]
}',
		'supinic/supibot-sql'
	)