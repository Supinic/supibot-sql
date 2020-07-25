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
		120,
		'boshy',
		NULL,
		'mention,pipe,whitelist',
		'Oh no no PepeLaugh',
		15000,
		NULL,
		NULL,
		'(async function boshy () {
	const sonicStart = 6620;
	const sonicEnd = 10664; 

	const skeletonStart = 11334;
	const skeletonEnd = 11603;

	const megamanStart = 12244;	
	const megamanEnd = 12760;	

	const mortalKombatStart = 13977;
	const mortalKombatEnd = 14307;

	const ganonStart = 14768;
	const ganonEnd = 14830;

	const missingnoStart = 17268; 
	const missingnoEnd = 17497;

	const solgrynStart = 18973;
	const solgrynEnd = solgrynStart + 2041;

	return {
		reply: \"Forsen has died the following amount of times at each boss: \" +
			\"Sonic: \" + (sonicEnd - sonicStart) +
			\", Skeleton: \" + (skeletonEnd - skeletonStart) +
			\", Megaman: \" + (megamanEnd - megamanStart) +
			\", Mortal Kombat: \" + (mortalKombatEnd - mortalKombatStart) + 
			\", Ganon: \" + (ganonEnd - ganonStart) +
			\", Missingno: \" + (missingnoEnd - missingnoStart) + 
			\", Solgryn: \" + (solgrynEnd - solgrynStart) + 
			\"; for a complete total of \" + solgrynEnd + \". LOST TO OATMEAL OMEGALUL\"
	};
})',
		NULL,
		'supinic/supibot-sql'
	)