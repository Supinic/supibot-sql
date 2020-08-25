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
		169,
		'gachisearch',
		'[\"gs\"]',
		'mention,pipe',
		'Searches for a given track in the gachi list, and attempts to post a link.',
		15000,
		NULL,
		NULL,
		'(async function gachiSearch (context, ...args) {
	const query = args.join(\" \");
	if (!query) {
		return {
			success: false,
			reply: \"No search query provided!\"
		};
	}

	const escaped = sb.Query.escapeLikeString(query);
	const data = await sb.Query.raw(sb.Utils.tag.trim `
		SELECT ID, Name
		FROM music.Track
		WHERE
			Track.ID IN ( SELECT Track FROM music.Track_Tag WHERE Tag = 6 )
			AND 
			(
				Name LIKE \'%${escaped}%\'
				OR EXISTS (
					SELECT 1
					FROM music.Alias
					WHERE
						Target_Table = \"Track\"
						AND Name LIKE \'%${escaped}%\'
						AND Target_ID = Track.ID
				)
				OR EXISTS (
					SELECT 1
					FROM music.Track AS Right_Version
					JOIN music.Track_Relationship ON Track_To = Right_Version.ID
					WHERE
						Relationship = \"Based on\"
						AND Right_Version.Name LIKE \'%${escaped}%\'
						AND Right_Version.ID = Track.ID
				)
			)
	`);

	if (data.length === 0) {
		return {
			success: false,
			reply: \"No tracks matching that query have been found!\"
		};
	}

	const [first, ...rest] = data;
	const others = rest.map(i => `\"${i.Name}\" (ID ${i.ID})`).join(\"; \");
	return {
		reply: `\"${first.Name}\" - https://supinic.com/track/detail/${first.ID} More results: ${others}`
	};
})',
		NULL,
		'supinic/supibot-sql'
	)