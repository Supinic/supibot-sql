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
		9,
		'#lotto',
		'() => ({
	emotes: Array(69).fill(0).map((i, ind) => String(ind)),
	limit: 5
})',
		'Function',
		'Rolls something akin to a Lotto lottery - 5 numbers, 1 to 69 each.'
	)