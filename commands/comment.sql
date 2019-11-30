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
		Code,
		Examples,
		Dynamic_Description
	)
VALUES
	(
		7,
		'comment',
		NULL,
		'Fetches a random comment from a set of 10 thousand randomly generated Youtube videos.',
		15000,
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
		'async () => {
	const extractRegex = /.*<span.*?>(.*?)<\\/span>/;
	const data = await sb.Utils.request({
		url: \"http://www.randomyoutubecomment.com/\",
		headers: {
			\"User-Agent\": \"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36\"
		},
		agentOptions: {
			rejectUnauthorized: false
		}
	});

	const match = data.match(extractRegex);
	if (match === null) {
		return {
			reply: \"No comment was available to fetch\"
		};
	}
	else {
		return {
			reply: sb.Utils.removeHTML(match[1])
		};
	}
}',
		'No arguments.

$comment',
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async () => {
	const extractRegex = /.*<span.*?>(.*?)<\\/span>/;
	const data = await sb.Utils.request({
		url: \"http://www.randomyoutubecomment.com/\",
		headers: {
			\"User-Agent\": \"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36\"
		},
		agentOptions: {
			rejectUnauthorized: false
		}
	});

	const match = data.match(extractRegex);
	if (match === null) {
		return {
			reply: \"No comment was available to fetch\"
		};
	}
	else {
		return {
			reply: sb.Utils.removeHTML(match[1])
		};
	}
}'