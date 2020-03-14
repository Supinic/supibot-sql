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
		Static_Data,
		Code,
		Examples,
		Dynamic_Description
	)
VALUES
	(
		160,
		'emotecheck',
		'[\"ec\"]',
		'Posts the list of each of Twitch\'s amazing \"global\" emote sets.',
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
		NULL,
		'(async function emoteCheck (context, type) {
	if (!type) {
		return { reply: \"No type provided\" };
	}

	switch (type) {
		case \"pride\":
			return { reply: \"PrideFlag PridePan PrideTrans PrideBisexual PrideLesbian PrideAsexual PrideBalloons PrideSaba PrideGive PrideTake PrideLionHey PrideLionYay PrideLionChomp PrideShine PrideParty PrideWingL PrideWingR PrideCheers PrideGasp PrideHi pride emote check gachiPRIDE\" };

		case \"food\":
		case \"fight\":
			return { reply: \"FightBagel FightBerry FightBox FightBurger FightCC FightCake FightCheese FightChips FightCookie FightCorn FightCup FightEgg FightFruit FightFry FightIce FightJello FightMash FightNacho FightPBJ FightPC FightPepper FightPie FightPizza FightPop FightPudding FightRamen FightSalad FightSardine FightSmoothie FightSmore FightSoda FightSoup FightSpag FightSub FightTomato food check OpieOP\" };

		case \"haha\":
		case \"holiday\":
			// Removed HahaDisapprove, as it is not publicly available despite being a part of the set
			return { reply: \"Haha2020 HahaBaby HahaBall HahaCat HahaDoge HahaDreidel HahaElf HahaGingercat HahaGoose HahaHide HahaLean HahaNutcracker HahaNyandeer HahaPoint HahaPresent HahaReindeer HahaShrugLeft HahaShrugMiddle HahaShrugRight HahaSleep HahaSnowhal HahaSweat HahaThink HahaThisisfine HahaTurtledove\"};

		case \"rpg\":
			return { reply: \"RPGAyaya RPGBukka RPGBukkaNoo RPGEmpty RPGEpicStaff RPGEpicSword RPGFei RPGFireball RPGGhosto RPGHP RPGMana RPGOops RPGPhatLoot RPGSeven RPGShihu RPGStaff RPGTreeNua RPGYonger TwitchRPG\" };

		case \"fb\":
		case \"football\":
			return { reply: \"FBBlock FBCatch FBChallenge FBPass FBPenalty FBRun FBSpiral FBtouchdown KKona 🏈\" };

		case \"kk\":
			return {
				reply: \"KKona KKomrade KKrikey KKurwa KKebab KKroissant KKozak KKhan KKarjala CCabron CChile GGyros BBrexit KKraut\"
			};

		case \"luv\":
			return {
				reply: \"LuvBlondeL LuvBlondeR LuvBlush LuvBrownL LuvBrownR LuvCool LuvGift LuvHearts LuvOops LuvPeekL LuvPeekR LuvSign LuvSnooze LuvUok\"
			};

		default: return { reply: \"No such emote set exists!\" };
	}
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function emoteCheck (context, type) {
	if (!type) {
		return { reply: \"No type provided\" };
	}

	switch (type) {
		case \"pride\":
			return { reply: \"PrideFlag PridePan PrideTrans PrideBisexual PrideLesbian PrideAsexual PrideBalloons PrideSaba PrideGive PrideTake PrideLionHey PrideLionYay PrideLionChomp PrideShine PrideParty PrideWingL PrideWingR PrideCheers PrideGasp PrideHi pride emote check gachiPRIDE\" };

		case \"food\":
		case \"fight\":
			return { reply: \"FightBagel FightBerry FightBox FightBurger FightCC FightCake FightCheese FightChips FightCookie FightCorn FightCup FightEgg FightFruit FightFry FightIce FightJello FightMash FightNacho FightPBJ FightPC FightPepper FightPie FightPizza FightPop FightPudding FightRamen FightSalad FightSardine FightSmoothie FightSmore FightSoda FightSoup FightSpag FightSub FightTomato food check OpieOP\" };

		case \"haha\":
		case \"holiday\":
			// Removed HahaDisapprove, as it is not publicly available despite being a part of the set
			return { reply: \"Haha2020 HahaBaby HahaBall HahaCat HahaDoge HahaDreidel HahaElf HahaGingercat HahaGoose HahaHide HahaLean HahaNutcracker HahaNyandeer HahaPoint HahaPresent HahaReindeer HahaShrugLeft HahaShrugMiddle HahaShrugRight HahaSleep HahaSnowhal HahaSweat HahaThink HahaThisisfine HahaTurtledove\"};

		case \"rpg\":
			return { reply: \"RPGAyaya RPGBukka RPGBukkaNoo RPGEmpty RPGEpicStaff RPGEpicSword RPGFei RPGFireball RPGGhosto RPGHP RPGMana RPGOops RPGPhatLoot RPGSeven RPGShihu RPGStaff RPGTreeNua RPGYonger TwitchRPG\" };

		case \"fb\":
		case \"football\":
			return { reply: \"FBBlock FBCatch FBChallenge FBPass FBPenalty FBRun FBSpiral FBtouchdown KKona 🏈\" };

		case \"kk\":
			return {
				reply: \"KKona KKomrade KKrikey KKurwa KKebab KKroissant KKozak KKhan KKarjala CCabron CChile GGyros BBrexit KKraut\"
			};

		case \"luv\":
			return {
				reply: \"LuvBlondeL LuvBlondeR LuvBlush LuvBrownL LuvBrownR LuvCool LuvGift LuvHearts LuvOops LuvPeekL LuvPeekR LuvSign LuvSnooze LuvUok\"
			};

		default: return { reply: \"No such emote set exists!\" };
	}
})'