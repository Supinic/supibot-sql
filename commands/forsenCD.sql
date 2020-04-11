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
		130,
		'forsenCD',
		'[\"pajaCD\"]',
		NULL,
		'A random quote from the two time! 1993, 1994 back to back blockbuster video game champion!',
		5000,
		0,
		0,
		0,
		0,
		NULL,
		0,
		0,
		0,
		0,
		1,
		0,
		0,
		'(() => {
	this.data.previousPosts = [];	
	return {
		repeats: 5,
		forsenCD: [
			\"Mishaps lead to recaps. Full vid coming soon. P.S. - My director Alex was fired.\",
			\"“If you hold the door open for someone and there’s no acknowledgement... remind them.”\",
			\"My incredible Mrs Assassin and I at the ESPYS. Yayayaya\",
			\"Hey @Nadeshot, hit me up on my flip phone when you get a chance.  I have some business negotiations to go over.\",
			\"Feels good to be back on @Twitch  Firm handshakes for the support... one hell of a stream. Yayayayaya!\",
			\"Hey guys, Jason Schrierer here, editor for Kotaku. Analytics shows that Kotaku is on the uprise, averaging 3-5 likes per tweet compared to 1-3 likes 1 year ago. I also wrote a book about video games, I don’t want to brag but it’s a favorite here at the offices. I hate myself\",
			\"Hey guys, Nathan Grayson here, hot shot reporter at the all mighty Kotaku website. You know, I’ve written so many cool things in my life, but nothing compares to my coverage of the 2009 mobile Angry Birds $100 tournament. And guess what... I won!!!\",
			\"The refs tried to rig the game and we still got it done. Toronto is nervousssssssssss. #warriors\",
			\"I got tore up by other online gamers all week. It happens to the best of us, even the two time back to back gorgeous 6’8 medallion wearing international video game champion in the online gaming community who hasn’t even reached his prime yet because he’s packed with steroids.\",
			\"Mobile gamers aren’t real gamers.\",
			\"God I love myself so much. I really do.\",
			\"There\'s a lot of twitter drama going on today and I want to add to it... John Wick is the most overrated movie/trilogy ever.\",
			\"I’m sick of these Fortnite excuses... ”unvault the pump” or “please, I need my baby precious pump shotty”, etc etc. Man up...  Jesus Christ. There’s a lot of 8 years olds looking to end you and this is your response?\",
			\"You and I?  Periscope?  ForsenCD He doesn’t know, loose guy chuckles, Reddit maximized ?  Thoughts Barbie doll?\",
			\"It\'s somethin\' about compact discs are transparent, etc, etc, it\'s like you know, these little chubby cheek wannabee... wannabees, like to laugh and giggle behind the scenes, right?\",
			\"I have bad diarrhea right now. Hot, acidic, out of control diarrhea. Give me 30 minutes until stream.\",
			\"You son of a bitch @shroud. After I’m done with the little guy, you’re next\",
			\"I\'m better than @xQc in Fortnite. Waaaaaaaaaaay better.\",
			\"How about you watch your ugly lookin mouth when you talk to the two time.\",
			\"Tiger Woods is a robot. Not quite sure what model number yet but my tech guy is looking into it.\",
			\"I love the #ChampionsClub. I also pay 50% in taxes for living in California. Video games are passion. I have a smooth jumper. I can sprint fast when neeed.\",
			\"I\'m not a happy champion.\",
			\"Steroid shipment didn\'t come in this morning so I ended the stream early. Tomorrow though, with 20k on the line, trust me it\'ll be a different ball game.\",
			\"I love being the best.\",
			\"I miss the #ChampionsClub. I can’t wait to get back to the arena tomorrow and dominate every little flappy gum dum dum weirdo. First stream of 2019....Yaya yaya yayaya.\",
			\"I’m sitting here right now in my heated infinity pool overlooking a dark valley with only one thing on my mind... what the hell has happened to Twitch? I’d like to help change this in 2019. I hope you do too.\",
			\"I can’t stand the word ‘esports’. This can’t be the word we all agreed upon. Sounds lazy. Sounds  manufactured. There has to be something better than ‘esports’.  I hate saying it and I hate looking at it. It’s ugly.\",
			\"In order to be the best you have to beat the best, and that’s why I’m not the best. I just can’t be beat. Think about it.\",
			\"Dear @shroud, Stop avoiding me and the 1990 diablo VT parked across the street from your 2 million dollar la casa in Southern California. If the binoculars bother you then just tell me via flip phone or dm. I want a duo Triple Threat challenge this week.\",
			\"It’s not esports, it’s pro gaming\",
			\"Oh god just because he took your ass down he’s the best @shroud ? You’re so god damn cocky it makes me sick\",
			\"I’m currently up in preparation for tomorrow’s 24 hour Modern Warfare stream. I will be challenged by sleep deprivation, hydration, blood flow, eye fatigue, voice box activation, connection, ping, power outages etc etc etc. Why am I doing this you ask?... ...Someone’s got to.\",
			\"Imagine being a full time Fortnite streamer. Hahahaha hahahaha Hahaha hahahaha haha hahaha Haha.\",
			\"Fortnite is gone. I couldn’t be more happier. Demonized children will turn back to normal 8th graders. The gaming industry will get back to quality soulful development. No more overhyped phoniness.\",
			\"It was.... generic. Unneeded. Disappointed. They created something legendary and then watered it down with a side salad.\",
			\"40k frames dropped in OBS in a few hours....that isn\'t gonna cut it in the Command Center. Stream cancelled. Infinity pool established. Good night. Yaya.\",
			\"Hey @timthetatman, imagine if you and I had the same meet and greet time at Twitchcon. Hahaha haha hahaha I might just stand in your line so you don’t feel lonely.\",
			\"Flip phone rang. UBISOFT on the line. It’s time to dive into some @GhostRecon. I’ll be playing the #GhostRecon Beta from the arena all night. #GhostFest #Sponsored\",
			\"Fortnite is the most overrated soulless game in the history of game development. Period. Gaming industry, lets move on.\",
			\"Nice new stream room Timmy Tenders! You went from streaming from a bedroom to now streaming from a cubicle at the Food 4 Less corporate offices.\",
			\"Power is still out in the Command Center. Escalating this to a higher government level. Halloween stream cancelled.... for now.\",
			\"I\'m trying to think who\'d I would hop in the ring with in my profession. Nobody is on my level in terms of athleticism and size.\",
			\"The best part about doing custom giveaways is knowing someone is getting memorabilia worth millions and millions.\",
			\"I\'ll go ahead and say it.... Piccadilly is growing on me. too soon? or?\",
			\"2019. What a year. This award is for everyone in the industry, passionate about gaming, passionate about entertaining. Congrats streaming industry. Let’s keep pushing it. The talent for next years streamer of the year nomination is going to be on another level and I love it.\",
			\"Star Wars Jedi: Fallen Order. Hardest Difficulty.... hahaha.\",
			\"Star Wars Jedi: Fallen Order. Hardest Difficulty is waaaaaay too easy. I look good by the way.  Always do.\",
			\"Mixer literally has a total of about 5k viewers right now. Hahahaha. What happened? Coronavirus?\",
			\"#Warzone is non stop fighting to the end. Winning a game feels very rewarding. On another note, my Lambo has 850hp. 12% increase with some modifications. It\'s fast.\",
			\"Today was incredible.... I\'m in incredible. Tomorrow, even more incredible and let me tell you why. I\'m going to be the most watched stream on any platform. Why you ask? Cmon.... it\'s FARTNITE SEASON 2 CHAPTER 2 EPISODE 2 2nd EDITION TIME!\",
			\"Listen, Champions Club. I know you just wanna relax and watch the greatest streamer ever dominate the gaming world in front of millions like usual. But this week we\'re changing up some things. No sub mode only..... Bring in these goofy loose gut fucks.\"
		]
	};
})()',
		'(async function forsenCD (context) {
	const post = sb.Utils.randArray(this.staticData.forsenCD.filter(i => !this.data.previousPosts.includes(i)));
	this.data.previousPosts.unshift(post);
	this.data.previousPosts.splice(this.staticData.repeats);

	return {
		reply: post + \" \" + context.invocation
	};
})',
		'No arguments.',
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function forsenCD (context) {
	const post = sb.Utils.randArray(this.staticData.forsenCD.filter(i => !this.data.previousPosts.includes(i)));
	this.data.previousPosts.unshift(post);
	this.data.previousPosts.splice(this.staticData.repeats);

	return {
		reply: post + \" \" + context.invocation
	};
})'