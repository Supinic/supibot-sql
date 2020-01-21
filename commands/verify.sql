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
		114,
		'verify',
		NULL,
		'Verifies a user to be able to use a specific command based on some requirement.',
		0,
		0,
		1,
		0,
		1,
		NULL,
		0,
		0,
		0,
		1,
		1,
		0,
		'(async function verify (context, type, user, ...rest) {
	if (!type || !user || rest.length === 0) {
		return {
			reply: \"Some arguments are missing!\"
		};
	}

	const allowedTypes = [\"bird\", \"cat\", \"dog\", \"fox\"];
	if (!allowedTypes.includes(type)) {
		return {
			reply: \"Unknown animal type provided!\"
		};
	}

	const userData = await sb.User.get(user);
	if (!userData) {
		return {
			reply: \"Invalid user provided!\"
		};
	}

	userData.Data.animals = userData.Data.animals ?? {};
	if (userData.data.animals[type]) {
		return {
			reply: `That user is already verified for ${type}(s). If you want to add more pictures, do it manually please :)`
		}
	}

	userData.Data.animals[type] = {
		verified: true,
		notes: rest.join(\" \")
	};

	await userData.saveProperty(\"Data\", userData.Data);

	return {
		reply: `Okay, they are now verified to use ${type}-related commands :)`
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function verify (context, type, user, ...rest) {
	if (!type || !user || rest.length === 0) {
		return {
			reply: \"Some arguments are missing!\"
		};
	}

	const allowedTypes = [\"bird\", \"cat\", \"dog\", \"fox\"];
	if (!allowedTypes.includes(type)) {
		return {
			reply: \"Unknown animal type provided!\"
		};
	}

	const userData = await sb.User.get(user);
	if (!userData) {
		return {
			reply: \"Invalid user provided!\"
		};
	}

	userData.Data.animals = userData.Data.animals ?? {};
	if (userData.data.animals[type]) {
		return {
			reply: `That user is already verified for ${type}(s). If you want to add more pictures, do it manually please :)`
		}
	}

	userData.Data.animals[type] = {
		verified: true,
		notes: rest.join(\" \")
	};

	await userData.saveProperty(\"Data\", userData.Data);

	return {
		reply: `Okay, they are now verified to use ${type}-related commands :)`
	};
})'