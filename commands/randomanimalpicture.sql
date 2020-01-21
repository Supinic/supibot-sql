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
		198,
		'randomanimalpicture',
		'[\"rap\", \"rbp\", \"rcp\", \"rdp\", \"rfp\"]',
		'Posts a random picture for a given animal type.',
		10000,
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
		'(async function randomAnimalPicture (context, type) {
	switch (context.invocation) {
		case \"rcp\": type = \"cat\"; break;
		case \"rdp\": type = \"dog\"; break;
		case \"rbp\": type = \"bird\"; break;
		case \"rfp\": type = \"fox\"; break;

		default: type = (typeof type === \"string\") ? type.toLowerCase() : null;
	}

	if (type === null) {
		return {
			reply: \"No type provided!\"
		};
	}
	else if (!context.user.Data.animals?.[type]) {
		return {
			reply: `Only people who have verified that they have a ${type} can use this command! Verify by $suggest-ing a picture of your ${type}(s).`
		};
	}
	
	let result = null;
	switch (type) {
		case \"bird\":
			result = JSON.parse(await sb.Utils.request(\"https://some-random-api.ml/img/bird\")).link;
			break;

		case \"cat\":
			result = JSON.parse(await sb.Utils.request(\"https://api.thecatapi.com/v1/images/search\"))[0].url;
			break;

		case \"dog\":
			result = JSON.parse(await sb.Utils.request(\"https://dog.ceo/api/breeds/image/random\")).message;
			break;

		case \"fox\":
			result = JSON.parse(await sb.Utils.request(\"https://some-random-api.ml/img/fox\")).message;
			break;
	}

	return {
		reply: result
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function randomAnimalPicture (context, type) {
	switch (context.invocation) {
		case \"rcp\": type = \"cat\"; break;
		case \"rdp\": type = \"dog\"; break;
		case \"rbp\": type = \"bird\"; break;
		case \"rfp\": type = \"fox\"; break;

		default: type = (typeof type === \"string\") ? type.toLowerCase() : null;
	}

	if (type === null) {
		return {
			reply: \"No type provided!\"
		};
	}
	else if (!context.user.Data.animals?.[type]) {
		return {
			reply: `Only people who have verified that they have a ${type} can use this command! Verify by $suggest-ing a picture of your ${type}(s).`
		};
	}
	
	let result = null;
	switch (type) {
		case \"bird\":
			result = JSON.parse(await sb.Utils.request(\"https://some-random-api.ml/img/bird\")).link;
			break;

		case \"cat\":
			result = JSON.parse(await sb.Utils.request(\"https://api.thecatapi.com/v1/images/search\"))[0].url;
			break;

		case \"dog\":
			result = JSON.parse(await sb.Utils.request(\"https://dog.ceo/api/breeds/image/random\")).message;
			break;

		case \"fox\":
			result = JSON.parse(await sb.Utils.request(\"https://some-random-api.ml/img/fox\")).message;
			break;
	}

	return {
		reply: result
	};
})'