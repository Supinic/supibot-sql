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
		72,
		'optout',
		'[\"unoptout\"]',
		NULL,
		'Makes it so you cannot be the target of a command. The command will not be executed. You can also append a message to explain why you opted out.',
		5000,
		0,
		0,
		1,
		0,
		NULL,
		0,
		0,
		0,
		1,
		0,
		0,
		0,
		NULL,
		'(async function optOut (context, ...args) {
	let deliberateGlobalOptout = false;
	const types = [\"command\", \"platform\", \"channel\"];
	const names = {};
	const filterData = {
		command: null,
		platform: null,
		channel: null
	};

	if (args[0] === \"all\") { // Opt out from everything
		args.splice(0, 1);
		deliberateGlobalOptout = true;
	}
	else if (args.every(i => !i.includes(\":\"))) { // Simple mode
		[filterData.command] = args;
		args.splice(0, 1);
	}
	else { // Advanced Mode
		for (let i = args.length - 1; i >= 0; i--) {
			const token = args[i];
			const [type, value] = token.split(\":\");
			if (type && value && types.includes(type)) {
				filterData[type] = value;
				args.splice(i, 1);
			}
		}
	}

	for (const [type, value] of Object.entries(filterData)) {
		if (value === null) {
			continue;
		}

		const module = sb[sb.Utils.capitalize(type)];
		const specificData = await module.get(value);
		if (!specificData) {
			return {
				success: false,
				reply: `Provided ${type} was not found!`
			};
		}
		else {
			if (module === sb.Command && !specificData.Opt_Outable) {
				return {
					success: false,
					reply: `You cannot opt out from this command!`
				};
			}

			names[type] = specificData.Name;
			filterData[type] = specificData.ID;
		}
	}

	if (!deliberateGlobalOptout && filterData.command === null) {
		return {
			success: false,
			reply: `A command (or \"all\" to optout globally) must be provided!`
		};
	}
	else if (filterData.channel && filterData.platform) {
		return {
			success: false,
			reply: \"Cannot specify both the channel and platform!\"
		};
	}

	const filter = sb.Filter.data.find(i => (
		i.Type === \"Opt-out\"
		&& i.Channel === filterData.channel
		&& i.Command === filterData.command
		&& i.Platform === filterData.platform
		&& i.User_Alias === context.user.ID
	));

	const { invocation } = context;
	if (filter) {
		if (filter.Issued_By !== context.user.ID) {
			return {
				success: false,
				reply: \"This command filter has not been created by you, so you cannot modify it!\"
			};
		}
		else if ((filter.Active && invocation === \"optout\") || (!filter.Active && invocation === \"unoptout\")) {
			return {
				success: false,
				reply: `You are already ${invocation}ed from that combination!`
			};
		}

		const suffix = (filter.Active) ? \"\" : \" again\";
		await filter.toggle();

		return {
			reply: `Succesfully ${invocation}ed${suffix}!`
		}
	}
	else {
		if (invocation === \"unoptout\") {
			return {
				success: false,
				reply: \"You haven\'t opted out from this combination yet, so it cannot be reversed!\"
			};
		}

		const filter = await sb.Filter.create({
			Active: true,
			Type: \"Opt-out\",
			User_Alias: context.user.ID,
			Command: filterData.command,
			Channel: filterData.channel,
			Platform: filterData.platform,
			Issued_By: context.user.ID
		});

		const commandPrefix = sb.Config.get(\"COMMAND_PREFIX\");
		let commandString = `command ${commandPrefix}${names.command}`;

		if (filterData.command === null) {
			commandString = \"all commands\";
		}

		let location = \"\";
		if (filterData.channel) {
			location = ` in channel ${names.channel}`;
		}
		else if (filterData.platform) {
			location = ` in platform ${names.platform}`;
		}

		return {
			reply: sb.Utils.tag.trim `
				You opted out from ${commandString}
				${location}
				(ID ${filter.ID}).
			`
		};
	}
})',
		NULL,
		'async (prefix) => {
	return [
		\"Opts you out of a specific command.\",
		\"While opted out, nobody can used that command with you as the parameter.\",
		\"You can also use a custom message to explain why you opted out or the reasoning.\",
		\"\",
		`${prefix}optout rl => You are now opted out from rl`,
		`${prefix}optout rl Just because. => You are now opted out from rl`
	];
}'
	)