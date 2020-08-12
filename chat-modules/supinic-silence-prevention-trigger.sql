INSERT INTO
	`chat_data`.`Chat_Module`
	(
		ID,
		Name,
		Events,
		Description,
		Code
	)
VALUES
	(
		4,
		'supinic-silence-prevention-trigger',
		'[\"online\", \"offline\"]',
		'Toggles the silence-prevention cron on/off on Supinic\'s stream going on/off.',
		'(async function (context) {
	const cron = sb.Cron.get(\"stream-silence-prevention\");
	if (!cron) {
		return;
	}
	else if (context.event === \"offline\" && cron.started) {
		cron.stop();
	}
	else if (context.event === \"online\" && !cron.started) {
		cron.start();
	}
})'
	)