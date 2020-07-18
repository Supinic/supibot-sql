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
		230,
		'alias',
		'[\"$\"]',
		'ping,pipe',
		'This command lets you create your own aliases (shorthands) for any other combination of commands and arguments. Check the extended help for step-by-step info.',
		2500,
		NULL,
		'({
	aliasLimit: 10,
	nameCheck: {
		regex: /^[\\w\\u00a9\\u00ae\\u2000-\\u3300\\ud83c\\ud000-\\udfff\\ud83d\\ud000-\\udfff\\ud83e[\\ud000-\\udfff]{2,25}$/,
		response: \"Your alias should only contain letters, numbers and be 2-25 characters long.\"
	},

	applyParameters: (context, aliasArguments, commandArguments) => {
		const resultArguments = [];
		const numberRegex = /\\${(\\d+)(\\+?)}/;
		const keywordRegex = /\\${(channel|executor)}/;

		for (const arg of aliasArguments) {
			if (numberRegex.test(arg)) {
				const [rawOrder, useRest] = arg.match(numberRegex).slice(1);
				const order = Number(rawOrder);
				if (!sb.Utils.isValidInteger(order)) {
					return {
						success: false,
						reply: `Invalid argument number \"${arg}\"!`
					};
				}

				let replacement = null;
				if (useRest) {
					const rest = commandArguments.slice(order);
					if (rest.length === 0) {
						return {
							success: false,
							reply: `There are no arguments starting from position ${order}!`
						};
					}

					replacement = rest.join(\" \");
				}
				else {
					replacement = commandArguments[order];
					if (!replacement) {
						return {
							success: false,
							reply: `Command argument number ${order} is missing!`
						};
					}
				}

				const result = arg.replace(numberRegex, replacement);
				resultArguments.push(...result.split(\" \"));
			}
			else if (keywordRegex.test(arg)) {
				const type = arg.match(keywordRegex)[1];
				if (type === \"channel\") {
					resultArguments.push(context.channel?.Name ?? \"[whispers]\");
				}
				else if (type === \"executor\") {
					resultArguments.push(context.user.Name);
				}
				else {
					return {
						success: false,
						reply: `This shouldn\'t happen :)`
					};
				}
			}
			else {
				resultArguments.push(arg);
			}
		}

		return {
			success: true,
			resultArguments
		};
	}

})',
		'(async function alias (context, type, ...args) {
	if (context.invocation === \"$\") {
		args = [type, ...args]; // This the command name
		type = \"run\"; // This is the implicit subcommand
	}

	if (!type) {
		return {
			reply: sb.Utils.tag.trim `
				This command lets you create your own command aliases.
				Check the extended help here:
				https://supinic.com/bot/command/${this.ID}
			`
		};
	}

	if (!context.user.Data.aliasedCommands) {
		context.user.Data.aliasedCommands = {};
		await context.user.saveProperty(\"Data\");
	}

	let changed = false;
	let reply = \"Unexpected reply! Contact @Supinic about this.\";
	const wrapper = new Map(Object.entries(context.user.Data.aliasedCommands));

	type = type.toLowerCase();
	switch (type) {
		case \"add\": {
			const [name, command, ...rest] = args;
			if (!name || !command) {
				return {
					success: false,
					reply: `You didn\'t provide a name, or a command! Use: alias add (name) (command) (...arguments)\"`
				};
			}
			else if (wrapper.has(name)) {
				return {
					success: false,
					reply: `Cannot add alias \"${name}\" - you already have one! You can either _edit_ its definion, _rename_ it or _remove_ it.`
				};
			}
			else if (!this.staticData.nameCheck.regex.test(name)) {
				return {
					success: false,
					reply: `Your alias name is not valid! ${this.staticData.nameCheck.response}`
				};
			}

			const commandCheck = sb.Command.get(command);
			if (!commandCheck) {
				return {
					success: false,
					reply: `Cannot create alias! The command \"${command}\" does not exist.`
				};
			}

			changed = true;
			wrapper.set(name, {
				name,
				invocation: command,
				args: rest,
				created: new sb.Date().toJSON(),
				lastEdit: null
			});

			reply = `Your alias \"${name}\" has been created successfully.`;
			break;
		}

		case \"check\": {
			const [name] = args;
			if (!name) {
				return {
					success: false,
					reply: `No alias name provided!`
				};
			}
			else if (!wrapper.has(name)) {
				return {
					success: false,
					reply: \"You don\'t have an alias with that name!\"
				};
			}

			const { invocation, args: commandArgs } = wrapper.get(name);
			return {
				reply: `Your alias \"${name}\" has this definition: ${invocation} ${commandArgs.join(\" \")}`
			};
		}

		case \"edit\": {
			const [name, command, ...rest] = args;
			if (!name || !command) {
				return {
					success: false,
					reply: `No alias or command name provided!\"`
				};
			}
			else if (!wrapper.has(name)) {
				return {
					success: false,
					reply: `You don\'t have an alias with this name!`
				};
			}

			const commandCheck = sb.Command.get(command);
			if (!commandCheck) {
				return {
					success: false,
					reply: `Cannot edit alias! The command \"${command}\" does not exist.`
				};
			}

			const obj = wrapper.get(name);
			obj.invocation = command;
			obj.args = rest;
			obj.lastEdit = new sb.Date().toJSON();

			changed = true;
			reply = `Your alias \"${name}\" has been successfully edited.`;

			break;
		}

		case \"list\": {
			const list = [...wrapper.keys()].map(i => `\"${i}\"`).sort().join(\", \");
			return {
				reply: (list.length === 0)
					? \"You currently don\'t have any aliases.\"
					: `Your aliases: ${list}.`
			};
		}

		case \"remove\": {
			const [name] = args;
			if (!name) {
				return {
					success: false,
					reply: `No alias name provided!`
				};
			}
			else if (!wrapper.has(name)) {
				return {
					success: false,
					reply: \"You don\'t have an alias with that name!\"
				};
			}

			changed = true;
			wrapper.delete(name);
			reply = `Your alias \"${name}\" has been succesfully removed.`;

			break;
		}

		case \"rename\": {
			const [oldName, newName] = args;
			if (!oldName || !newName) {
				return {
					success: false,
					reply: \"You must provide both the current alias name and the new one!\"
				};
			}
			else if (!wrapper.has(oldName)) {
				return {
					success: false,
					reply: \"Can\'t rename - you don\'t have an alias with that name!\"
				};
			}

			changed = true;
			wrapper.set(newName, wrapper.get(oldName));
			wrapper.get(newName).lastEdit = new sb.Date().toJSON();
			wrapper.delete(oldName);

			reply = `Your alias \"${oldName}\" has been succesfully renamed to \"${newName}\".`;

			break;
		}

		case \"run\": {
			const [name] = args;
			if (!name) {
				return {
					success: false,
					reply: \"No alias name provided!\"
				};
			}
			else if (!wrapper.has(name)) {
				return {
					success: false,
					reply: \"You don\'t have an alias with that name!\"
				};
			}

			const { invocation, args: aliasArguments } = wrapper.get(name);
			const { success, reply, resultArguments } = this.staticData.applyParameters(context, aliasArguments, args.slice(1));
			if (!success) {
				return { success, reply };
			}

			const commandData = sb.Command.get(invocation);
			if (context.append.pipe && !commandData.Flags.pipe) {
				return {
					success: false,
					reply: `Cannot use command ${invocation} inside of a pipe, despite being wrapped in an alias!`
				};
			}

			const aliasCount = (context.append.aliasCount ?? 0) + 1;
			if (aliasCount > this.staticData.aliasLimit) {
				return {
					success: false,
					reply: sb.Utils.tag.trim `
						Your alias cannot continue!
						It causes more than ${this.staticData.aliasLimit} alias calls.
						Please reduce the complexity first.
					`
				};
			}

			const result = await sb.Command.checkAndExecute(
				invocation,
				resultArguments,
				context.channel,
				context.user,
				{
					...context.append,
					aliasCount,
					platform: context.platform,
					skipPending: true,
					skipPing: true
				}
			);

			return {
				aliased: true,
				...result
			};
		}

		case \"spy\": {
			const [targetUser, targetAlias] = args;
			if (!targetUser) {
				return {
					success: false,
					reply: \"No target username provided!\"
				};
			}

			const target = await sb.User.get(targetUser);
			if (!target) {
				return {
					success: false,
					reply: \"Invalid user provided!\"
				};
			}

			const aliases = target.Data.aliasedCommands;
			if (!aliases || Object.keys(aliases).length === 0) {
				return {
					success: false,
					reply: \"They currently don\'t have any aliases!\"
				};
			}			
			else if (!targetAlias) {
				const list = Object.keys(aliases).map(i => `\"${i}\"`).sort().join(\", \");
				return {
					reply: `Their aliases: ${list}.`
				};
			}
			else if (!aliases[targetAlias]) {
				return {
					success: false,
					reply: \"They don\'t have an alias with that name!\"
				};
			}

			const { invocation, args: commandArgs } = aliases[targetAlias];
			return {
				reply: `Their alias \"${targetAlias}\" has this definition: ${invocation} ${commandArgs.join(\" \")}`
			};
		}

		default: return {
			success: false,
			reply: sb.Utils.tag.trim `
				Invalid sub-command provided!
				Check the extended help here:
			   	https://supinic.com/bot/command/${this.ID}
			`
		}
	}

	if (changed) {
		context.user.Data.aliasedCommands = Object.fromEntries(wrapper);
		await context.user.saveProperty(\"Data\");
	}

	return { reply };
})',
		'async (prefix) => {
	return [
		\"Meta-command that lets you create aliases (or shorthands) for existing commands or their combinations.\",
		\"You have to first create an alias, and then run it. You can manage your aliases by listing, checking, removing and adding.\",
		\"\",
		
		`<code>${prefix}alias add (name) (definition)</code>`,
		`Creates your command alias, e.g.:`,
		`<code>${prefix}alias add <u>hello</u> translate to:german Hello!</code>`,
		\"\",
		
		`<code>${prefix}$ (name)</code>`,
		`<code>${prefix}alias run (name)</code>`,
		\"Runs your command alias!, e.g.:\",
		
		`<code>${prefix}$ <u>hello</u></code> => Hallo!`,
		`<code>${prefix}alias run <u>hello</u></code> => Hallo!`,
		\"\",		
		
		`<code>${prefix}alias check (name)</code>`,
		\"Posts the definition of given alias to chat, e.g.:\",
		`<code>${prefix}alias check <u>hello</u></code> => \"translate to:german Hello!\"`,
		\"\",

		`<code>${prefix}alias edit (name)</code>`,
		\"Edits an existing alias, without the need of removing and re-adding it.\",
		`<code>${prefix}alias edit <u>hello</u></code> => \"translate to:italian Hello!\"`,
		\"\",

		`<code>${prefix}alias rename (old-name) (new-name)</code>`,
		\"Renames your command alias from old-name to new-name.\",
		\"\",

		`<code>${prefix}alias list</code>`,
		\"Lists all your currently active aliases.\",
		\"\",
		
		`<code>${prefix}alias remove (name)</code>`,
		\"Removes your command alias with the given name.\",
		\"\",

		\"<h5>Replacements</h5>\",
		\"Replaces a symbol in your alias with a value depending on its name.\",
		`<ul>
			<li>
				<code>\\${#}</code> (e.g. \\${0}, \\${1}, ...)
				<br>
				Replaced by argument number # in your alias execution.
				<br>
				<code>${prefix}alias add test translate to:\\${0} hello!</code>
				<br>
				<code>${prefix}alias run test spanish</code> => <code>${prefix}translate to:spanish hello</code>
			</li>
			<br>
			<li>
				<code>\\${#+}</code> (e.g. \\${0+}, \\${1+}, ...)
				<br>
				Replaced by argument number # and all the following arguments in your alias execution.
				<br>
				<code>${prefix}alias add test translate to:\\${0} hello, \\${1+}!</code>
				<br>
				<code>${prefix}alias run test spanish my friends</code> => <code>${prefix}translate to:spanish hello, my friends!</code>
			</li>
			<br>
			<li>
				<code>\\${channel}</code>
				<br>
				The channel name the alias is run in.
				<br>
				<code>${prefix}alias add test remind \\${channel} hello!</code>
				<br>
				<code>${prefix}alias run test</code> => <code>${prefix}remind (channel-name) hello!</code>
			</li>
			<br>
			<li>
				<code>\\${executor}</code>
				<br>
				The username of the person running the alias.
				<br>
				<code>${prefix}alias add test remind person hello from \\${executor}!</code>
				<br>
				<code>${prefix}alias run test</code> => <code>${prefix}remind person hello from (you)!</code>
			</li>
		</ul>`
	];
}',
		'supinic/supibot-sql'
	)