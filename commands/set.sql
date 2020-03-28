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
		Static_Data,
		Code,
		Examples,
		Dynamic_Description
	)
VALUES
	(
		207,
		'set',
		NULL,
		'Sets certain variables within Supibot. You can then use these to enhance your User Experience.',
		5000,
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
		NULL,
		'(async function set (context, type, ...args) {
	if (!type) {
		return {
			success: false,
			reply: \"No type provided!\"
		};
	}

	type = type.toLowerCase();
	switch (type) {
		case \"location\": {
			let hidden = false;
			if (args[0] === \"private\" || args[0] === \"hidden\") {
				hidden = true;
				args.shift();
			}

			if (args.length === 0) {
				return {
					success: false,
					reply: \"No location provided!\"
				};
			}
			
			const query = args.join(\" \");
			const { components, coordinates, formatted, location, placeID, success } = await sb.Utils.fetchGeoLocationData(
				sb.Config.get(\"API_GOOGLE_GEOCODING\"),
				query
			);

			if (!success) {
				return {
					success: false,
					reply: \"No location found for given query!\"
				};
			}

			context.user.Data.location = {
				formatted,
				placeID,
				components,
				hidden,
				coordinates: coordinates ?? location,
				original: query
			};

			await context.user.saveProperty(\"Data\", context.user.Data);
			return {
				reply: `Successfully set your ${hidden ? \"private\" : \"public\"} location!`
			};
		}
	}
	
	return {
		reply: \"Invalid type provided!\"
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function set (context, type, ...args) {
	if (!type) {
		return {
			success: false,
			reply: \"No type provided!\"
		};
	}

	type = type.toLowerCase();
	switch (type) {
		case \"location\": {
			let hidden = false;
			if (args[0] === \"private\" || args[0] === \"hidden\") {
				hidden = true;
				args.shift();
			}

			if (args.length === 0) {
				return {
					success: false,
					reply: \"No location provided!\"
				};
			}
			
			const query = args.join(\" \");
			const { components, coordinates, formatted, location, placeID, success } = await sb.Utils.fetchGeoLocationData(
				sb.Config.get(\"API_GOOGLE_GEOCODING\"),
				query
			);

			if (!success) {
				return {
					success: false,
					reply: \"No location found for given query!\"
				};
			}

			context.user.Data.location = {
				formatted,
				placeID,
				components,
				hidden,
				coordinates: coordinates ?? location,
				original: query
			};

			await context.user.saveProperty(\"Data\", context.user.Data);
			return {
				reply: `Successfully set your ${hidden ? \"private\" : \"public\"} location!`
			};
		}
	}
	
	return {
		reply: \"Invalid type provided!\"
	};
})'