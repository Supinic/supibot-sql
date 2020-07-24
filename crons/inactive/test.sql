INSERT INTO
	`chat_data`.`Cron`
	(
		ID,
		Name,
		Expression,
		Description,
		Defer,
		Code,
		Type,
		Active
	)
VALUES
	(
		1,
		'test',
		'*/10 * * * * *',
		'Testing.',
		NULL,
		'(async function test (...args) {
	this.data.test = this.data.test || [];
	this.data.test.push(sb.Utils.random(1, 100));

	console.log(this.data.test);	
})',
		'Bot',
		0
	)