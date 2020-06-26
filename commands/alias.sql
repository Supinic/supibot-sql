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
		5000,
		NULL,
		'({
	nameCheck: {
		regex: /^[\\w]{2,25}$/,
		response: \"Your alias should only contain letters, numbers and be 2-25 characters long.\"
	},

	applyParameters: (aliasArguments, commandArguments) => {
		const resultArguments = [];

		for (let i = 0; i < aliasArguments.length; i++) {
			const targetArgument = aliasArguments[i];

			if (targetArgument.startsWith(\"${\") && targetArgument.endsWith(\"}\")) {
				const replacementName = targetArgument.substr(2, targetArgument.length - 3);

				if (replacementName === \"channel\") {
					resultArguments.push(context.channel?.Name ?? \"[whispers]\");
				}
				else if (replacementName === \"executor\") {
					resultArguments.push(context.user.Name);
				}
				else if (!Number.isNaN(Number(replacementName))) {
					// ${0}
					const argument = commandArguments[Number(replacementName) + 1];
					if (argument) {
						resultArguments.push(argument);
					}
					else {
						// Argument is empty, don\'t add anything.
					}
				}
				else if (
					!Number.isNaN(Number(replacementName.substr(0, replacementName.length - 3)))
					&& replacementName[replacementName.length - 3] === \"+\"
				) {	
					// ${0+}
					const argument = commandArguments.slice(Number(replacementName.substr(0, replacementName.length - 3)) + 1);
					if (argument) {
						resultArguments.splice(resultArguments.length, 0, ...argument);
					}
					else {
						// Arguments are empty, don\'t add anything.
					}
				}
				else {
					return {
						success: false,
						reply: `Unknown replacement ${targetArgument}.`
					}
				}
			}
			else {
				// not a replacement
				resultArguments.push(targetArgument);
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
				This command lets you created your own command aliases.
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
	const wrapper = new Map(Object.entries(context.user.Data.aliasedCommands));

	type = type.toLowerCase();
	switch (type) {
		case \"add\": {
			const [name, command, ...rest] = args;
			if (!name || !command) {
				return {
					success: false,
					reply: `No alias or command name provided! Use \"alias add (alias-name) (command-name) (...arguments)\"`
				};
			}
			else if (wrapper.has(name)) {
				return {
					success: false,
					reply: `Cannot create alias - you already have an alias with this name! To replace it, remove it first.`
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
				args: rest
			});

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
				reply: `Definition of alias \"${name}\": ${invocation} ${commandArgs.join(\" \")}`
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
					reply: `Cannot edit - you don\'t have an alias wit this name!`
				};
			}

			const commandCheck = sb.Command.get(command);
			if (!commandCheck) {
				return {
					success: false,
					reply: `Cannot edit alias! The command \"${command}\" does not exist.`
				};
			}

			changed = true;
			wrapper.set(name, {
				name,
				invocation: command,
				args: rest
			});

			break;
		}

		case \"list\": {
			const list = [...wrapper.keys()].sort().join(\", \");
			return {
				reply: (list.length === 0)
					? \"You currently don\'t have any aliases.\"
					: `Your aliases: ${list}`
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
			const { success, reply, resultArguments } = this.staticData.applyParameters(aliasArguments, args);
			if (!success) {
				return { success, reply };
			}

			const result = await sb.Command.checkAndExecute(
				invocation,
				resultArguments,
				context.channel,
				context.user,
				{
					...context.append,
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

		default: return {
			success: false,
			reply: sb.Utils.tag.trim `
				Invalid sub-command provided!
				Check the extended help here:
			    https://supinic.com/bot/command/${this.ID}
		    `
		}
	}

	let addendum = \"\";
	if (changed) {
		context.user.Data.aliasedCommands = Object.fromEntries(wrapper);
		await context.user.saveProperty(\"Data\");
		addendum = \"Changes saved successfully!\";
	}

	return {
		reply: `Alias operation ${type} succeeded. ${addendum}`
	};
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

		`<code>${prefix}alias list</code>`,
		\"Lists all your currently active aliases.\",
		\"\",
		
		`<code>${prefix}alias remove (name)</code>`,
		\"Removes your command alias with the given name.\",
		\"\",
	];
}',
		'supinic/supibot-sql'
	)