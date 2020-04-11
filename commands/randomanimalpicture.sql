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
		198,
		'randomanimalpicture',
		'[\"rap\", \"rbp\", \"rcp\", \"rdp\", \"rfp\"]',
		NULL,
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
		0,
		NULL,
		'(async function randomAnimalPicture (context, type) {
	const types = [\"cat\", \"dog\", \"bird\", \"fox\"];
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
	else if (!types.includes(type)) {
		return {
			reply: \"That type is not supported!\"
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
			result = (await sb.Got.instances.SRA(\"img/birb\").json()).link;
			break;

		case \"cat\":
			result = (await sb.Got(\"https://api.thecatapi.com/v1/images/search\").json())[0].url;
			break;

		case \"dog\":
			result = (await sb.Got(\"https://dog.ceo/api/breeds/image/random\").json()).message;
			break;

		case \"fox\":
			result = (await sb.Got.instances.SRA(\"img/fox\").json()).link;
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
	const types = [\"cat\", \"dog\", \"bird\", \"fox\"];
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
	else if (!types.includes(type)) {
		return {
			reply: \"That type is not supported!\"
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
			result = (await sb.Got.instances.SRA(\"img/birb\").json()).link;
			break;

		case \"cat\":
			result = (await sb.Got(\"https://api.thecatapi.com/v1/images/search\").json())[0].url;
			break;

		case \"dog\":
			result = (await sb.Got(\"https://dog.ceo/api/breeds/image/random\").json()).message;
			break;

		case \"fox\":
			result = (await sb.Got.instances.SRA(\"img/fox\").json()).link;
			break;
	}

	return {
		reply: result
	};
})'