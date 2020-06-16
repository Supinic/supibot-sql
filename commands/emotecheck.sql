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
		160,
		'emotecheck',
		'[\"ec\"]',
		'ping,pipe',
		'Posts the list of each of Twitch\'s amazing \"global\" emote sets.',
		15000,
		NULL,
		'({
	emotes: {
		pride: [
			\"PrideCrown\", 
			\"PrideDragon\", 
			\"PrideFloat\", 
			\"PrideHeartL\", 
			\"PrideLaugh\", 
			\"PridePaint\", 
			\"PrideStrong\", 
			\"PrideUwu\", 
			\"PrideWorld\", 
			\"PrideFlower\", 
			\"PrideHeartL\", 
			\"PrideLaugh\", 
			\"PrideLion\", 
			\"PrideLove\", 
			\"PrideRhino\", 
			\"PrideShrug\", 
			\"PrideWave\", 
			\"PrideWorld\"
		],
		pride2019: [
			\"PrideAsexual\",
			\"PrideBalloons\",
			\"PrideBisexual\",
			\"PrideCheers\",
			\"PrideFlag\",
			\"PrideGasp\",
			\"PrideGive\",
			\"PrideHi\",
			\"PrideLesbian\",
			\"PrideLionChomp\",
			\"PrideLionHey\",
			\"PrideLionYay\",
			\"PridePan\",
			\"PrideParty\",
			\"PrideSaba\",
			\"PrideShine\",
			\"PrideTake\",
			\"PrideTrans\",
			\"PrideWingL\",
			\"PrideWingR\"
		],
		haha: [
			\"Haha2020\",
			\"HahaBaby\",
			\"HahaBall\",
			\"HahaCat\",
			\"HahaDoge\",
			\"HahaDreidel\",
			\"HahaElf\",
			\"HahaGingercat\",
			\"HahaGoose\",
			\"HahaHide\",
			\"HahaLean\",
			\"HahaNutcracker\",
			\"HahaNyandeer\",
			\"HahaPoint\",
			\"HahaPresent\",
			\"HahaReindeer\",
			\"HahaShrugLeft\",
			\"HahaShrugMiddle\",
			\"HahaShrugRight\",
			\"HahaSleep\",
			\"HahaSnowhal\",
			\"HahaSweat\",
			\"HahaThink\",
			\"HahaThisisfine\",
			\"HahaTurtledove\"
		],
		rpg: [
			\"RPGAyaya\",
			\"RPGBukka\",
			\"RPGBukkaNoo\",
			\"RPGEmpty\",
			\"RPGEpicStaff\",
			\"RPGEpicSword\",
			\"RPGFei\",
			\"RPGFireball\",
			\"RPGGhosto\",
			\"RPGHP\",
			\"RPGMana\",
			\"RPGOops\",
			\"RPGPhatLoot\",
			\"RPGSeven\",
			\"RPGShihu\",
			\"RPGStaff\",
			\"RPGTreeNua\",
			\"RPGYonger\"
		],
		fb: [
			\"FBBlock\",
			\"FBCatch\",
			\"FBChallenge\",
			\"FBPass\",
			\"FBPenalty\",
			\"FBRun\",
			\"FBSpiral\",
			\"FBtouchdown\"
		],

		get food () { return this.fight; },
		fight: [
			\"FightBagel\",
			\"FightBerry\",
			\"FightBox\",
			\"FightBurger\",
			\"FightCC\",
			\"FightCake\",
			\"FightCheese\",
			\"FightChips\",
			\"FightCookie\",
			\"FightCorn\",
			\"FightCup\",
			\"FightEgg\",
			\"FightFruit\",
			\"FightFry\",
			\"FightIce\",
			\"FightJello\",
			\"FightMash\",
			\"FightNacho\",
			\"FightPBJ\",
			\"FightPC\",
			\"FightPepper\",
			\"FightPie\",
			\"FightPizza\",
			\"FightPop\",
			\"FightPudding\",
			\"FightRamen\",
			\"FightSalad\",
			\"FightSardine\",
			\"FightSmoothie\",
			\"FightSmore\",
			\"FightSoda\",
			\"FightSoup\",
			\"FightSpag\",
			\"FightSub\",
			\"FightTomato\"
		],
		
		get kk () { return this.KKona; },
		KKona: [
			\"BBrexit\",
			\"CCabron\",
			\"CChile\",
			\"GGyros\",
			\"KKarjala\",
			\"KKebab\",
			\"KKhan\",
			\"KKiwi\",
			\"KKomrade\",
			\"KKona\",
			\"KKozak\",
			\"KKraut\",
			\"KKrikey\",
			\"KKroissant\",
			\"KKurwa\"
		],
		
		get luv () { return this.valentine; },
		valentine: [
			\"LuvBlondeL\",
			\"LuvBlondeR\",
			\"LuvBlush\",
			\"LuvBrownL\",
			\"LuvBrownR\",
			\"LuvCool\",
			\"LuvGift\",
			\"LuvHearts\",
			\"LuvOops\",
			\"LuvPeekL\",
			\"LuvPeekR\",
			\"LuvSign\",
			\"LuvSnooze\",
			\"LuvUok\"
		],

		sir: [ // Implemented on 2020-04-02, a \"reward\" for having 2FA on your Twitch account
			\"SirMad\",
			\"SirPrise\",
			\"SirSad\",
			\"SirShield\",
			\"SirSword\",
			\"SirUwU\"
		]
	}
})',
		'(async function emoteCheck (context, type) {
	if (!type) {
		return { reply: \"No type provided\" };
	}

	const result = this.staticData.emotes[type];
	return {
		reply: (result)
			? result.join(\" \")
			: \"No emote set available for that type\"
	};
})',
		NULL,
		'supinic/supibot-sql'
	)