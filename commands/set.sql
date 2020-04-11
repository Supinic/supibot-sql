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
		207,
		'set',
		NULL,
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
		1,
		0,
		'({
	variables: [
		{
			names: [\"location\"],
			description: \"Sets your IRL location in the context of Supibot. This is then used in commands like $weather, $time, $corona, ...\"
		}
	]
})',
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
		'async (prefix) => {
	const row = await sb.Query.getRow(\"chat_data\", \"Command\");
	await row.load(207);
	
	const { variables } = eval(row.values.Static_Data);
	const list = variables.map(i => `<li><code>${i.names.join(\"/\")}</code> ${i.description}</li>`).join(\"\");

	return [
		\"Sets a variable that you can then use in Supibot\'s commands.\",
		\"\",

		`<code>${prefix}set (variable) (data)</code>`,
		`Sets the variable of the given type with given data.`,
		\"\",
		
		\"List of variables:\",
		`<ul>${list}</ul>`		
	];	
}'
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