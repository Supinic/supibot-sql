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
		153,
		'authkey',
		NULL,
		'Works with an authentication string used to access supinic.com APIs that require a login; outside of Twitch login.',
		10000,
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
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function authKey (context, type) {
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
})'