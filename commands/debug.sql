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
		9,
		'debug',
		NULL,
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
		const scriptContext = vm.createContext({version: process.version, context, sb});
		const ForeignObject = vm.runInContext(\"Object\", scriptContext);
		let result = await script.runInNewContext(scriptContext, { timeout: 2500 });
		if (typeof result !== \"undefined\") {
			if (result?.constructor === ForeignObject) {
				result = JSON.stringify(result, null, 4);
			}

			return {
				reply: String(result)
			};
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
		const scriptContext = vm.createContext({version: process.version, context, sb});
		const ForeignObject = vm.runInContext(\"Object\", scriptContext);
		let result = await script.runInNewContext(scriptContext, { timeout: 2500 });
		if (typeof result !== \"undefined\") {
			if (result?.constructor === ForeignObject) {
				result = JSON.stringify(result, null, 4);
			}

			return {
				reply: String(result)
			};
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