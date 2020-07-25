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
		'mention,pipe',
		'Fetches a random gachi track from the gachi list, excluding Bilibili and Nicovideo videos with no Youtube reuploads',
		5000,
		NULL,
		NULL,
		'(async function randomGachi (context, ...args) {
	const prefixRow = await sb.Query.getRow(\"data\", \"Video_Type\");
	await prefixRow.load(1);

	let userFavourites = null;
	let linkOnly = false;
	const favRegex = /^fav(ou?rite)?/;

	for (let i = args.length - 1; i >= 0; i--) {
		const token = args[i];
		if (token === \"linkOnly:true\") {
			linkOnly = true;
			args.splice(i, 1);
		}
		else if (favRegex.test(token)) {
			const name = token.split(\":\")[1];
			if (name) {
				userFavourites = await sb.User.get(name);
				if (!userFavourites) {
					return {
						success: false,
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
			reply: `No available YouTube tracks found for given combination of parameters!`
		};
	}

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
		'supinic/supibot-sql'
	)