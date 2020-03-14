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
		71,
		'roll',
		NULL,
		'Rolls a random number. If nothing is specified, rolls 1-100. You can also specify <number X>d<number Y> for X amount of dice rolls with Y sides each.',
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
		1,
		0,
		NULL,
		'(async function roll (context, first, second) {
	let format = [1, 100];
	if (Number(first) && Number(second)) {
		first = Number(first);
		second = Number(second);

		if (first > Number.MAX_SAFE_INTEGER || second > Number.MAX_SAFE_INTEGER) {
			return {
				reply: \"That\'s too much.\"
			};
		}

		const number = sb.Utils.random(first, second);
		if (context.append.pipe) {
			return { reply: String(number ) };
		}
		else {
			return { reply: \"Your specific roll (no dice) is \" + number };
		}
	}
	else if (first) {
		format = first.split(\"d\").map(Number);
	}

	if (format[0] < 0) {
		const prefix = (Math.abs(format[0]) === 1) ? \"die\" : \"dice\";
		return { reply: \"Don\'t take my \" + prefix + \" away FeelsBadMan\" };
	}
	else if (format[0] === 0) {
		return { reply: \"I can\'t roll with no dice FeelsBadMan\" };
	}
	else if (format[1] <= 1) {
		const prefix = (format[0] === 1) ? \"Die\" : \"Dice\";
		const sides = (format[1] === 0)
			? \"no sides\"
			: (format[1] === 1) ? \"one side\" : \"negative amount of sides\";

		return { reply: `${prefix} with ${sides}? That\'s an interesting topological exercise...` };
	}
	else if (format.length !== 2 || format.some(i => i <= 0 || Math.trunc(i) !== i || !Number.isFinite(i))) {
		return { reply: \"Incorrect dice format!\" };
	}
	else if (format[1] > Number.MAX_SAFE_INTEGER) {
		const prefix = (format[0] === 1)? \"That die has\" : \"Those dice have\";
		return { reply: prefix + \" way too many sides!\" };
	}
	else if (format[0] > 1.0e6) {
		return { reply: \"I don\'t have that many dice!\" };
	}

	let sum = 0;
	let [times, sides] = format;
	while (times--) {
		sum += sb.Utils.random(1, sides);
	}

	if (sum === Infinity) {
		return { reply: \"WAYTOODANK\" };
	}
	else if (context.append.pipe) {
		return { reply: String(sum) };
	}
	else {
		return { reply: \"Your roll is \" + sum + \".\" };
	}
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function roll (context, first, second) {
	let format = [1, 100];
	if (Number(first) && Number(second)) {
		first = Number(first);
		second = Number(second);

		if (first > Number.MAX_SAFE_INTEGER || second > Number.MAX_SAFE_INTEGER) {
			return {
				reply: \"That\'s too much.\"
			};
		}

		const number = sb.Utils.random(first, second);
		if (context.append.pipe) {
			return { reply: String(number ) };
		}
		else {
			return { reply: \"Your specific roll (no dice) is \" + number };
		}
	}
	else if (first) {
		format = first.split(\"d\").map(Number);
	}

	if (format[0] < 0) {
		const prefix = (Math.abs(format[0]) === 1) ? \"die\" : \"dice\";
		return { reply: \"Don\'t take my \" + prefix + \" away FeelsBadMan\" };
	}
	else if (format[0] === 0) {
		return { reply: \"I can\'t roll with no dice FeelsBadMan\" };
	}
	else if (format[1] <= 1) {
		const prefix = (format[0] === 1) ? \"Die\" : \"Dice\";
		const sides = (format[1] === 0)
			? \"no sides\"
			: (format[1] === 1) ? \"one side\" : \"negative amount of sides\";

		return { reply: `${prefix} with ${sides}? That\'s an interesting topological exercise...` };
	}
	else if (format.length !== 2 || format.some(i => i <= 0 || Math.trunc(i) !== i || !Number.isFinite(i))) {
		return { reply: \"Incorrect dice format!\" };
	}
	else if (format[1] > Number.MAX_SAFE_INTEGER) {
		const prefix = (format[0] === 1)? \"That die has\" : \"Those dice have\";
		return { reply: prefix + \" way too many sides!\" };
	}
	else if (format[0] > 1.0e6) {
		return { reply: \"I don\'t have that many dice!\" };
	}

	let sum = 0;
	let [times, sides] = format;
	while (times--) {
		sum += sb.Utils.random(1, sides);
	}

	if (sum === Infinity) {
		return { reply: \"WAYTOODANK\" };
	}
	else if (context.append.pipe) {
		return { reply: String(sum) };
	}
	else {
		return { reply: \"Your roll is \" + sum + \".\" };
	}
})'