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
		Dynamic_Description
	)
VALUES
	(
		207,
		'set',
		NULL,
		'ping,pipe',
		'Sets certain variables within Supibot. You can then use these to enhance your User Experience.',
		5000,
		NULL,
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
					reply: \"No location provided!\",
					cooldown: 2500
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
		'async (prefix, values) => {
	const { variables } = values.getStaticData();
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