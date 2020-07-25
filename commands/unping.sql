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
		181,
		'unping',
		'[\"dpm\", \"reping\"]',
		'mention,pipe',
		'Sets/unsets a command pinging you when it\'s being invoked.',
		5000,
		NULL,
		NULL,
		'(async function unping (context, ...args) {
	const { invocation } = context;
	if (args.length === 0) {
		return {
			success: false,
			reply: `You must provide something to ${invocation} from! Check the command\'s help if needed.`
		};
	}

	let deliberateGlobalUnping = false;
	const types = [\"command\", \"platform\", \"channel\"];
	const names = {};
	const filterData = {
		command: null,
		platform: null,
		channel: null
	};

	if (args[0] === \"all\") { // Unping from everything
		args.splice(0, 1);
		deliberateGlobalUnping = true;
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
			names[type] = specificData.Name;
			filterData[type] = specificData.ID;
		}
	}

	if (!deliberateGlobalUnping && filterData.command === null) {
		return {
			success: false,
			reply: `A command (or \"all\" to ${invocation} globally) must be provided!`
		};
	}
	else if (filterData.channel && filterData.platform) {
		return {
			success: false,
			reply: \"Cannot specify both the channel and platform!\"
		};
	}

	const filter = sb.Filter.data.find(i => (
		i.Type === \"Unping\"
		&& i.Channel === filterData.channel
		&& i.Command === filterData.command
		&& i.Platform === filterData.platform
		&& i.User_Alias === context.user.ID
	));

	if (filter) {
		if ((filter.Active && invocation === \"unping\") || (!filter.Active && invocation === \"reping\")) {
			return {
				success: false,
				reply: `You already used this command on this combination!`
			};
		}

		const suffix = (filter.Active) ? \"\" : \" again\";
		await filter.toggle();

		return {
			reply: `Succesfully ${invocation}ed${suffix}!`
		}
	}
	else {
		if (invocation === \"reping\") {
			return {
				success: false,
				reply: \"You haven\'t made this command not ping you yet!\"
			};
		}

		const filter = await sb.Filter.create({
			Active: true,
			Type: \"Unping\",
			User_Alias: context.user.ID,
			Command: filterData.command,
			Channel: filterData.channel,
			Platform: filterData.platform,
			Issued_By: context.user.ID
		});

		let commandString = `command ${sb.Command.prefix}${names.command}`;
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
				You made the command ${commandString} not ping you
				${location}
				(ID ${filter.ID}).
			`
		};
	}
})',
		NULL,
		'supinic/supibot-sql'
	)