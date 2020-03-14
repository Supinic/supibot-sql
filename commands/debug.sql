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
		9,
		'debug',
		NULL,
		'supiniHack ',
		0,
		0,
		1,
		1,
		1,
		NULL,
		0,
		0,
		0,
		0,
		1,
		0,
		NULL,
		'(async function debug (context, ...args) {
	const vm = require(\"vm\");
	let script = null;	

	try {
		script = new vm.Script(\"(async () => {\\n\" + args.join(\" \") + \"\\n})()\");
	}
	catch (e) {
		return {
			reply: \"Parse: \" + e.toString()
		};
	}

	try {
		const result = await script.runInNewContext({setTimeout, setInterval, require, context, sb}, { timeout: 2500 });
		if (typeof result !== \"undefined\") {
			return { reply: String(result) };
		}
		else {
			return { 
				reply: \"Done\"
			};
		}
	}
	catch (e) {
		console.log(e);
		return { 
			reply: \"Execute: \" + e.toString()
		};
	}		
})


/*
async (extra, ...args) => {
	try {
		const result = await eval(\"(async () => {\\n\" + args.join(\" \") + \"\\n})()\");
		if (typeof result !== \"undefined\") {
			return { reply: String(result) };
		}
		else {
			return { reply: \"Done\" };
		}
	}
	catch (e) {
		console.log(e);
		return { reply: \"Error: \" + e.toString() };
	}
}
*/',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function debug (context, ...args) {
	const vm = require(\"vm\");
	let script = null;	

	try {
		script = new vm.Script(\"(async () => {\\n\" + args.join(\" \") + \"\\n})()\");
	}
	catch (e) {
		return {
			reply: \"Parse: \" + e.toString()
		};
	}

	try {
		const result = await script.runInNewContext({setTimeout, setInterval, require, context, sb}, { timeout: 2500 });
		if (typeof result !== \"undefined\") {
			return { reply: String(result) };
		}
		else {
			return { 
				reply: \"Done\"
			};
		}
	}
	catch (e) {
		console.log(e);
		return { 
			reply: \"Execute: \" + e.toString()
		};
	}		
})


/*
async (extra, ...args) => {
	try {
		const result = await eval(\"(async () => {\\n\" + args.join(\" \") + \"\\n})()\");
		if (typeof result !== \"undefined\") {
			return { reply: String(result) };
		}
		else {
			return { reply: \"Done\" };
		}
	}
	catch (e) {
		console.log(e);
		return { reply: \"Error: \" + e.toString() };
	}
}
*/'