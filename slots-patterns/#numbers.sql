INSERT INTO
	`data`.`Slots_Pattern`
	(
		ID,
		Name,
		Pattern,
		Type,
		Notes
	)
VALUES
	(
		11,
		'#numbers',
		'(extra, type, number) => {
	const target = Number(number);
	if (!target || target > Number.MAX_SAFE_INTEGER || target < 1 || Math.trunc(target) !== target) {
		return \"The number must be an integer between 2 and \" + Number.MAX_SAFE_INTEGER;
	}

	return {
		roll: () => sb.Utils.random(1, target),
		uniqueItems: target
	};
}',
		'Function',
		'Rolls 3 numbers, from 1 to the given maximum. Must not exceed the maximum integer value, which is 9007199254740991.'
	)