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
		72,
		'optout',
		'[\"unoptout\"]',
		'ping,skip-banphrase',
		'Makes it so you cannot be the target of a command - the command will not be executed at all. For detailed usage, please check the extended help.',
		5000,
		NULL,
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
		'async (prefix) => {
	return [
		\"Opts you out of a specific command.\",
		\"While opted out from command, nobody can use it with you as the parameter.\",
		\"\",
	
		`<code><u>Simple mode</u></code>`,
		`<code>${prefix}optout (command)</code>`,
		`Will opt you out from a given command`,
		\"\",

		`<code><u>Total mode</u></code>`,
		`<code>${prefix}optout all</code>`,
		`Will opt you out from all current and future opt-outable commands, everywhere.`,
		\"\",

		`<code><u>Advanced mode</u></code>`,
		`<code>${prefix}optout channel:(chn) command:(cmd) platform:(p)</code>`,
		`Will opt you out from a specified combination of channel/command/platform.`,
		\"E.g.:\",
		`<ul>
			<li> 
				<code>${prefix}optout command:rl channel:supibot</code>
				Will opt you out from command rl only in channel \"supibot\".
			</li>
			<li> 
				<code>${prefix}optout command:rl platform:twitch</code>
				Will opt you out from command rl only in Twitch.
			</li>
			<li> 
				<code>${prefix}optout channel:supibot</code>
				Will opt you out from all opt-outable commands, only in channel \"supibot\".
			</li>
		</ul>`,
	];
}'
	)