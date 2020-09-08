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
		241,
		'spm',
		NULL,
		'developer,mention,whitelist',
		'Various utility subcommands related to supibot-package-manager.',
		0,
		NULL,
		NULL,
		'(async function spm (context, ...args) {
	const operation = args.shift()?.toLowerCase();
	if (!operation) {
		throw new sb.Error({
			message: \"No spm operation provided\"
		});
	}

	const type = args.shift()?.toLowerCase();
	if (!type) {
		throw new sb.Error({
			message: \"No operation type provided\"
		});
	}

	if (operation === \"dump\") {
		const fs = require(\"fs\").promises;
		switch (type) {
			case \"commands\": {
				const promises = sb.Command.data.map(async (command) => {
					const dir = `/code/spm/commands/${command.Name}`;
					try {
						await fs.opendir(dir);
					}
					catch (e) {
						if (e.message.includes(\"ENOENT\")) {
							await fs.mkdir(dir);
						}
						else {
							throw e;
						}
					}

					await command.serialize({ filePath: `${dir}/index.js` });
				});

				await Promise.all(promises);

				return {
					reply: `Saved ${promises.length} commands into supibot-package-manager/commands peepoHackies`
				};
			}

			default:
				throw new sb.Error({
					message: \"Unsupported dump operation\"
				});
		}

	}
	else if (operation === \"load\") {
		throw new sb.Error({
			message: \"Not implemented\"
		});
	}
	else {
		throw new sb.Error({
			message: \"Invalid operation\"
		});
	}
})',
		NULL,
		'supinic/supibot-sql'
	)