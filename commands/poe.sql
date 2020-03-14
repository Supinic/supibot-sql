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
		117,
		'poe',
		NULL,
		'Checks the current price of any recently traded item. $poe <league> <item>',
		7500,
		0,
		1,
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
		'(async function poe (context, league, ...item) {
	const now = new sb.Date();
	const patching = new sb.Date(\"2020-03-13 18:00 GMT+1\")
	const live = new sb.Date(\"2020-03-13 21:00 GMT+1\")

	const strings = [
		(now > patching) ? \"Patching has started!\" : `Patching will start ${sb.Utils.timeDelta(patching)}.`,
		(now > live) ? \"The league should be live!\" : `League wil go live ${sb.Utils.timeDelta(live)}.`
	];

	return {
		reply: `Current status of 3.10 Delirium League: ${strings.join(\" \")}`
	};

	/*	
        item =  item.join(\" \").toLowerCase();
    
        if (!league) {
            return { reply: \"You dum dum - no league\" };
        }
        const leagueCheck = (await sb.Query.getRecordset(rs => rs
            .select(\"ID\", \"Name\")
            .from(\"poe\", \"League\")
            .where(\"Name = %s OR Abbreviation = %s\", league, league)
        ))[0];
        if (!leagueCheck) {
            return { reply: \"You dum dum - stoopid league\" };
        }	
    
        if (!item) {
            return { reply: \"You dum dum - no item provided\" };
        }
        const itemCheck = (await sb.Query.getRecordset(rs => rs
            .select(\"ID\", \"Name\")
            .from(\"poe\", \"Item\")
            .where(\"Name = %s\", item)
            .where({condition: item === \"tabula rasa\"}, \"Details_ID LIKE \'%6l\'\")
        ))[0];
        if (!itemCheck) {
            return { reply: \"You dum dum - invalid item\" };
        }
    
        const value = (await sb.Query.getRecordset(rs => rs
            .select(\"Chaos_Equivalent AS Chaos\")
            .from(\"poe\", \"Price\")
            .where(\"Item = %n\", itemCheck.ID)
            .where(\"League = %n\", leagueCheck.ID)		
            .orderBy(\"ID DESC\")
            .limit(1)
        ))[0];
        if (!value) {
            return { reply: \"Unfortunately, it seems like nobody is trading \" + itemCheck.Name + \" on \" + leagueCheck.Name + \".\" };
        }	
    
        const exaltValue = (await sb.Query.getRecordset(rs => rs
            .select(\"Chaos_Equivalent AS Chaos\")
            .from(\"poe\", \"Price\")
            .where(\"Item = %n\", 5)
            .where(\"League = %n\", leagueCheck.ID)		
            .orderBy(\"ID DESC\")
            .limit(1)
        ))[0];
    
        const altValue = (await sb.Query.getRecordset(rs => rs
            .select(\"Chaos_Equivalent AS Chaos\")
            .from(\"poe\", \"Price\")
            .where(\"Item = %n\", 49)
            .where(\"League = %n\", leagueCheck.ID)		
            .orderBy(\"ID DESC\")
            .limit(1)
        ))[0];
    
        console.log(value, exaltValue, altValue);
    
        let priceString = (value.Chaos >= 1)
            ? itemCheck.Name + \" is currently worth ~\" + value.Chaos + \" Chaos Orb(s)\"
            : itemCheck.Name + \" is currently worth ~\" + Math.ceil(value.Chaos / altValue.Chaos) + \" Orb(s) of Alteration\"
        
        if (value.Chaos > exaltValue.Chaos) {
            priceString += \" or ~\" + sb.Utils.round(value.Chaos / exaltValue.Chaos, 2) + \" Exalted Orb(s)\"
        }
    
        return { 
            reply: priceString + \" on \" + leagueCheck.Name
        };
    */
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function poe (context, league, ...item) {
	const now = new sb.Date();
	const patching = new sb.Date(\"2020-03-13 18:00 GMT+1\")
	const live = new sb.Date(\"2020-03-13 21:00 GMT+1\")

	const strings = [
		(now > patching) ? \"Patching has started!\" : `Patching will start ${sb.Utils.timeDelta(patching)}.`,
		(now > live) ? \"The league should be live!\" : `League wil go live ${sb.Utils.timeDelta(live)}.`
	];

	return {
		reply: `Current status of 3.10 Delirium League: ${strings.join(\" \")}`
	};

	/*	
        item =  item.join(\" \").toLowerCase();
    
        if (!league) {
            return { reply: \"You dum dum - no league\" };
        }
        const leagueCheck = (await sb.Query.getRecordset(rs => rs
            .select(\"ID\", \"Name\")
            .from(\"poe\", \"League\")
            .where(\"Name = %s OR Abbreviation = %s\", league, league)
        ))[0];
        if (!leagueCheck) {
            return { reply: \"You dum dum - stoopid league\" };
        }	
    
        if (!item) {
            return { reply: \"You dum dum - no item provided\" };
        }
        const itemCheck = (await sb.Query.getRecordset(rs => rs
            .select(\"ID\", \"Name\")
            .from(\"poe\", \"Item\")
            .where(\"Name = %s\", item)
            .where({condition: item === \"tabula rasa\"}, \"Details_ID LIKE \'%6l\'\")
        ))[0];
        if (!itemCheck) {
            return { reply: \"You dum dum - invalid item\" };
        }
    
        const value = (await sb.Query.getRecordset(rs => rs
            .select(\"Chaos_Equivalent AS Chaos\")
            .from(\"poe\", \"Price\")
            .where(\"Item = %n\", itemCheck.ID)
            .where(\"League = %n\", leagueCheck.ID)		
            .orderBy(\"ID DESC\")
            .limit(1)
        ))[0];
        if (!value) {
            return { reply: \"Unfortunately, it seems like nobody is trading \" + itemCheck.Name + \" on \" + leagueCheck.Name + \".\" };
        }	
    
        const exaltValue = (await sb.Query.getRecordset(rs => rs
            .select(\"Chaos_Equivalent AS Chaos\")
            .from(\"poe\", \"Price\")
            .where(\"Item = %n\", 5)
            .where(\"League = %n\", leagueCheck.ID)		
            .orderBy(\"ID DESC\")
            .limit(1)
        ))[0];
    
        const altValue = (await sb.Query.getRecordset(rs => rs
            .select(\"Chaos_Equivalent AS Chaos\")
            .from(\"poe\", \"Price\")
            .where(\"Item = %n\", 49)
            .where(\"League = %n\", leagueCheck.ID)		
            .orderBy(\"ID DESC\")
            .limit(1)
        ))[0];
    
        console.log(value, exaltValue, altValue);
    
        let priceString = (value.Chaos >= 1)
            ? itemCheck.Name + \" is currently worth ~\" + value.Chaos + \" Chaos Orb(s)\"
            : itemCheck.Name + \" is currently worth ~\" + Math.ceil(value.Chaos / altValue.Chaos) + \" Orb(s) of Alteration\"
        
        if (value.Chaos > exaltValue.Chaos) {
            priceString += \" or ~\" + sb.Utils.round(value.Chaos / exaltValue.Chaos, 2) + \" Exalted Orb(s)\"
        }
    
        return { 
            reply: priceString + \" on \" + leagueCheck.Name
        };
    */
})'