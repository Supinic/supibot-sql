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
		153,
		'authkey',
		NULL,
		'developer,mention,pipe',
		'Works with an authentication string used to access supinic.com APIs that require a login; outside of Twitch login.',
		10000,
		NULL,
		NULL,
		'(async function authKey (context, type) {
	switch (type) {
		case \"invalidate\": {
			if (!context.user.Data.authKey) {
				return { reply: \"You have no authentication key set up!\" };
			}

			context.user.Data.authKey = null;
			await context.user.saveProperty(\"Data\", context.user.Data);
		
			return { reply: \"Authentication key invalidated successfully.\" };
		}
		
		case \"generate\": {
			if (!context.privateMessage) {
				return { reply: \"You can only generate a new key via private messages!\" };
			}
			else if (context.user.Data.authKey) {				
				return { reply: \"You already have an authentication key set up! Invalidate it first and then generate a new one.\" };
			}
			
			const crypto = require(\"crypto\");
			const hashString = crypto.createHash(\"sha3-256\")
				.update(context.user.Name)
				.update(context.user.ID.toString())
				.update(new sb.Date().valueOf().toString())
				.update(crypto.randomBytes(256).toString())
				.digest(\"hex\");				
				
			context.user.Data.authKey = hashString;
			await context.user.saveProperty(\"Data\", context.user.Data);
				
			return { reply: \"Your authentication key is: \" + hashString };
		}
	
		default: return { reply: \"You must supply a mode, one of: \\\"generate\\\", \\\"invalidate\\\"\" };
	}
})',
		NULL,
		'supinic/supibot-sql'
	)