INSERT INTO
	`chat_data`.`Cron`
	(
		ID,
		Name,
		Expression,
		Description,
		Code,
		Type,
		Active
	)
VALUES
	(
		11,
		'prune-cooldown-manager',
		'30 * * * * *',
		'Periodically removes all expired cooldowns',
		'(async function pruneCooldownManager () {
	sb.CooldownManager && sb.CooldownManager.prune();
})',
		'Bot',
		1
	)