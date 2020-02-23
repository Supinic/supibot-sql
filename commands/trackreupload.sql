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
		143,
		'trackreupload',
		'[\"tr\"]',
		'Sets a track ID in the list already to have the next track as a reupload. The next track can be an existing ID (if it\'s not a reupload already) or a new link, in which case it gets added to list.',
		10000,
		0,
		0,
		0,
		1,
		'Only available for people who know what they\'re doing Kappa',
		0,
		0,
		0,
		1,
		1,
		0,
		'(async function trackReload (extra, existingID, reuploadLink) {
	existingID = Number(existingID);
	
	if (!sb.Utils.isValidInteger(existingID)) {
		return { reply: \"First argument must be positive finite integer!\" };
	}
	else if (!reuploadLink) {
		return { reply: \"Second argument must either be positive finite integer or a link!\" };
	}

	const reuploadCheck = Number(reuploadLink);
	if (sb.Utils.isValidInteger(reuploadCheck)) {
		const row = await sb.Query.getRecordset(rs => rs
			.select(\"Link\")
			.select(\"Link_Prefix\")
			.from(\"music\", \"Track\")
			.join(\"data\", \"Video_Type\")
			.where(\"Track.ID = %n\", reuploadCheck)
			.single()
		);
		
		if (!row) {
			return { reply: \"Given reupload ID does not exist!\" };
		}

		reuploadLink = row.Link_Prefix.replace(sb.Config.get(\"VIDEO_TYPE_REPLACE_PREFIX\"), row.Link);
	}

	const result = await sb.Got.instances.Supinic({
		method: \"POST\",
		url: \"track/reupload\",
		searchParams: new sb.URLParams()
			.set(\"reuploadLink\", reuploadLink)
			.set(\"existingID\", existingID)
			.toString()
	}).json();
	
	return { 
		reply: \"Result: \" + result.data.message + \".\"
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function trackReload (extra, existingID, reuploadLink) {
	existingID = Number(existingID);
	
	if (!sb.Utils.isValidInteger(existingID)) {
		return { reply: \"First argument must be positive finite integer!\" };
	}
	else if (!reuploadLink) {
		return { reply: \"Second argument must either be positive finite integer or a link!\" };
	}

	const reuploadCheck = Number(reuploadLink);
	if (sb.Utils.isValidInteger(reuploadCheck)) {
		const row = await sb.Query.getRecordset(rs => rs
			.select(\"Link\")
			.select(\"Link_Prefix\")
			.from(\"music\", \"Track\")
			.join(\"data\", \"Video_Type\")
			.where(\"Track.ID = %n\", reuploadCheck)
			.single()
		);
		
		if (!row) {
			return { reply: \"Given reupload ID does not exist!\" };
		}

		reuploadLink = row.Link_Prefix.replace(sb.Config.get(\"VIDEO_TYPE_REPLACE_PREFIX\"), row.Link);
	}

	const result = await sb.Got.instances.Supinic({
		method: \"POST\",
		url: \"track/reupload\",
		searchParams: new sb.URLParams()
			.set(\"reuploadLink\", reuploadLink)
			.set(\"existingID\", existingID)
			.toString()
	}).json();
	
	return { 
		reply: \"Result: \" + result.data.message + \".\"
	};
})'