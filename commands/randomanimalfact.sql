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
		197,
		'randomanimalfact',
		'[\"raf\", \"rbf\", \"rcf\", \"rdf\", \"rff\"]',
		NULL,
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
		0,
		NULL,
		'(async function randomAnimalFact (context, type) {
	const types = [\"cat\", \"dog\", \"bird\", \"fox\"];
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
			result = (await sb.Got.instances.SRA(\"facts/bird\").json()).fact;
			break;

		case \"cat\":
			result = (await sb.Got(\"https://catfact.ninja/fact\").json()).fact;
			break;

		case \"dog\":
			result = (await sb.Got(\"https://dog-api.kinduff.com/api/facts\").json()).facts[0];
			break;

		case \"fox\":
			result = (await sb.Got.instances.SRA(\"facts/fox\").json()).fact;
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
	const types = [\"cat\", \"dog\", \"bird\", \"fox\"];
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
			result = (await sb.Got.instances.SRA(\"facts/bird\").json()).fact;
			break;

		case \"cat\":
			result = (await sb.Got(\"https://catfact.ninja/fact\").json()).fact;
			break;

		case \"dog\":
			result = (await sb.Got(\"https://dog-api.kinduff.com/api/facts\").json()).facts[0];
			break;

		case \"fox\":
			result = (await sb.Got.instances.SRA(\"facts/fox\").json()).fact;
			break;
	}

	return {
		reply: result
	};
})'