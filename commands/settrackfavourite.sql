INSERT INTO
	`chat_data`.`Command`
	(
		ID,
		Name,
		Aliases,
		Flags,
		Description,
		Cooldown,
		Whitelist_Response,
		Static_Data,
		Code,
		Dynamic_Description,
		Source
	)
VALUES
	(
		236,
		'settrackfavourite',
		'[\"stf\"]',
		'mention',
		'Lets you favourite a track in Supinic\'s track list from chat. Not toggleable, only sets the favourite. You can unset or check the favourite on the website. https://supinic.com/track/gachi/list',
		5000,
		NULL,
		NULL,
		'(async function setTrackFavourite (context, link) {

})',
		NULL,
		'supinic/supibot-sql'
	)