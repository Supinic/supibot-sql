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
		197,
		'randomanimalfact',
		'[\"raf\", \"rbf\", \"rcf\", \"rdf\", \"rff\"]',
		'Posts a random fact about a selected animal type.',
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
		'(async function randomAnimalFact (context, type) {
	switch (context.invocation) {
		case \"rcf\": type = \"cat\"; break;
		case \"rdf\": type = \"dog\"; break;
		case \"rbf\": type = \"bird\"; break;
		case \"rff\": type = \"fox\"; break;

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
			result = JSON.parse(await sb.Utils.request(\"https://some-random-api.ml/facts/bird\")).fact;
			break;

		case \"cat\":
			result = JSON.parse(await sb.Utils.request(\"https://catfact.ninja/fact\")).fact;
			break;

		case \"dog\":
			result = JSON.parse(await sb.Utils.request(\"https://dog-api.kinduff.com/api/facts\")).facts[0];
			break;

		case \"fox\":
			result = JSON.parse(await sb.Utils.request(\"https://some-random-api.ml/facts/fox\")).fact;
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
	Code = '(async function randomAnimalFact (context, type) {
	switch (context.invocation) {
		case \"rcf\": type = \"cat\"; break;
		case \"rdf\": type = \"dog\"; break;
		case \"rbf\": type = \"bird\"; break;
		case \"rff\": type = \"fox\"; break;

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
			result = JSON.parse(await sb.Utils.request(\"https://some-random-api.ml/facts/bird\")).fact;
			break;

		case \"cat\":
			result = JSON.parse(await sb.Utils.request(\"https://catfact.ninja/fact\")).fact;
			break;

		case \"dog\":
			result = JSON.parse(await sb.Utils.request(\"https://dog-api.kinduff.com/api/facts\")).facts[0];
			break;

		case \"fox\":
			result = JSON.parse(await sb.Utils.request(\"https://some-random-api.ml/facts/fox\")).fact;
			break;
	}

	return {
		reply: result
	};
})'