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
		120,
		'boshy',
		NULL,
		NULL,
		'Oh no no PepeLaugh',
		15000,
		0,
		0,
		0,
		1,
		NULL,
		0,
		0,
		0,
		1,
		1,
		0,
		0,
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
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function boshy () {
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
})'