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
		114,
		'verify',
		NULL,
		'mention,pipe,system,whitelist',
		'Verifies a user to be able to use a specific command based on some requirement.',
		0,
		NULL,
		NULL,
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
	if (userData.Data.animals[type]) {
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
		'supinic/supibot-sql'
	)