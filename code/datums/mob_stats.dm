/datum/stat_holder
	var/mob/living/holder
	var/list/stat_list = list()
	var/list/datum/perk/perks = list()
	var/list/obj/effect/perk_stats = list() // Holds effects representing perks, to display them in stat()

/datum/stat_holder/New(mob/living/L)
	holder = L
	for(var/sttype in subtypesof(/datum/stat))
		var/datum/stat/S = new sttype
		stat_list69S.name69 = S

/datum/stat_holder/Destroy()
	holder = null
	return ..()

/datum/stat_holder/proc/check_for_shared_perk(ability_bitflag)
	for(var/datum/perk/target_perk in perks)
		if(target_perk.check_shared_ability(ability_bitflag))
			return TRUE
	return FALSE

/* Uncomment when we have69ore than 1 bitflag for shared abilities
/datum/stat_holder/proc/check_for_shared_perks(list/ability_bitflags)
	for(var/datum/perk/target_perk in perks)
		if(target_perk.check_shared_abilities(ability_bitflags))
			return TRUE
	return FALSE
*/
/datum/stat_holder/proc/addTempStat(statName,69alue, timeDelay, id = null)
	var/datum/stat/S = stat_list69statName69
	S.addModif(timeDelay,69alue, id)
	SEND_SIGNAL(holder, COMSIG_STAT, S.name, S.getValue(), S.getValue(TRUE))


/datum/stat_holder/proc/removeTempStat(statName, id)
	if(!id)
		crash_with("no id passed to removeTempStat(")
	var/datum/stat/S = stat_list69statName69
	S.remove_modifier(id)

/datum/stat_holder/proc/getTempStat(statName, id)
	if(!id)
		crash_with("no id passed to getTempStat(")
	var/datum/stat/S = stat_list69statName69
	return S.get_modifier(id)

/datum/stat_holder/proc/changeStat(statName,69alue)
	var/datum/stat/S = stat_list69statName69
	S.changeValue(Value)
	SEND_SIGNAL(holder, COMSIG_STAT, S.name, S.getValue(), S.getValue(TRUE))

/datum/stat_holder/proc/setStat(statName,69alue)
	var/datum/stat/S = stat_list69statName69
	S.setValue(Value)

/datum/stat_holder/proc/getStat(statName, pure = FALSE)
	if (!islist(statName))
		var/datum/stat/S = stat_list69statName69
		if(holder)
			SEND_SIGNAL(holder, COMSIG_STAT, S.name, S.getValue(), S.getValue(TRUE))
		return S ? S.getValue(pure) : 0
	else
		log_debug("passed list to getStat()")

//	Those are accept list of stats
//	Compound stat checks.
//	Lowest69alue among the stats passed in
/datum/stat_holder/proc/getMinStat(var/list/namesList, pure = FALSE)
	if(!islist(namesList))
		log_debug("passed non-list to getMinStat()")
		return 0
	var/lowest = INFINITY
	for (var/name in namesList)
		if(getStat(name, pure) < lowest)
			lowest = getStat(name, pure)
	return lowest

//	Get the highest69alue among the stats passed in
/datum/stat_holder/proc/getMaxStat(var/list/namesList, pure = FALSE)
	if(!islist(namesList))
		log_debug("passed non-list to getMaxStat()")
		return 0
	var/highest = -INFINITY
	for (var/name in namesList)
		if(getStat(name, pure) > highest)
			highest = getStat(name, pure)
	return highest

//	Sum total of the stats
/datum/stat_holder/proc/getSumOfStat(var/list/namesList, pure = FALSE)
	if(!islist(namesList))
		log_debug("passed non-list to getSumStat()")
		return 0
	var/sum = 0
	for (var/name in namesList)
		sum += getStat(name, pure)
	return sum

//	Get the average (mean)69alue of the stats
/datum/stat_holder/proc/getAvgStat(var/list/namesList, pure = FALSE)
	if(!islist(namesList))
		log_debug("passed non-list to getAvgStat()")
		return 0
	var/avg = getSumOfStat(namesList, pure)
	return avg / namesList.len

/datum/stat_holder/proc/copyTo(var/datum/stat_holder/recipient)
	for(var/i in stat_list)
		var/datum/stat/S = stat_list69i69
		var/datum/stat/RS = recipient.stat_list69i69
		S.copyTo(RS)

	for(var/datum/perk/P in perks)
		recipient.addPerk(P.type)


// return69alue from 0 to 1 based on69alue of stat,69ore stat69alue less return69alue
// use this proc to get69ultiplier for decreasing delay time (exaple: "50 * getMult(STAT_ROB, STAT_LEVEL_ADEPT)"  this will result in 5 seconds if stat STAT_ROB = 0 and result will be 0 if STAT_ROB = STAT_LEVEL_ADEPT)
/datum/stat_holder/proc/getMult(statName, statCap = STAT_LEVEL_MAX, pure = FALSE)
    if(!statName)
        return
    return 1 -69ax(0,min(1,getStat(statName, pure)/statCap))

/datum/stat_holder/proc/getPerk(perkType)
	RETURN_TYPE(/datum/perk)
	var/datum/perk/path = ispath(perkType) ? perkType : text2path(perkType) // Adds support for textual argument so that it can be called through69V easily
	if(path)
		return locate(path) in perks

/// The69ain, public proc to add a perk to a69ob. Accepts a path or a stringified path.
/datum/stat_holder/proc/addPerk(perkType)
	. = FALSE
	if(!getPerk(perkType))
		var/datum/perk/P = new perkType
		perks += P
		P.assign(holder)
		. = TRUE


/// The69ain, public proc to remove a perk from a69ob. Accepts a path or a stringified path.
/datum/stat_holder/proc/removePerk(perkType)
	var/datum/perk/P = getPerk(perkType)
	if(P)
		perks -= P
		P.remove()

/datum/stat_mod
	var/time = 0
	var/value = 0
	var/id

/datum/stat_mod/New(_delay, _affect, _id)
	if(_delay == INFINITY)
		time = -1
	else
		time = world.time + _delay
	value = _affect
	id = _id



/datum/stat
	var/name = "Character stat"
	var/desc = "Basic characteristic, you are not supposed to see this. Report to admins."
	var/value = STAT_VALUE_DEFAULT
	var/list/mods = list()

/datum/stat/proc/addModif(delay, affect, id)
	for(var/elem in69ods)
		var/datum/stat_mod/SM = elem
		if(SM.id == id)
			if(delay == INFINITY)
				SM.time = -1
			else
				SM.time = world.time + delay
			SM.value = affect
			return
	mods += new /datum/stat_mod(delay, affect, id)

/datum/stat/proc/remove_modifier(id)
	for(var/elem in69ods)
		var/datum/stat_mod/SM = elem
		if(SM.id == id)
			mods.Remove(SM)
			return

/datum/stat/proc/get_modifier(id)
	for(var/elem in69ods)
		var/datum/stat_mod/SM = elem
		if(SM.id == id)
			return SM

/datum/stat/proc/changeValue(affect)
	value =69alue + affect

/datum/stat/proc/getValue(pure = FALSE)
	if(pure)
		return69alue
	else
		. =69alue
		for(var/elem in69ods)
			var/datum/stat_mod/SM = elem
			if(SM.time != -1 && SM.time < world.time)
				mods -= SM
				qdel(SM)
				continue
			. += SM.value

/datum/stat/proc/setValue(value)
	src.value =69alue

/datum/stat/proc/copyTo(var/datum/stat/recipient)
	recipient.value = getValue(TRUE)

/datum/stat/productivity
	name = STAT_MEC
	desc = "The world hadn't ever had so69any69oving parts or so few labels. Character's ability in building and using69arious tools.."

/datum/stat/cognition
	name = STAT_COG
	desc = "Too69any dots, not enough lines. Knowledge and ability to create new items."

/datum/stat/biology
	name = STAT_BIO
	desc = "What's the difference between being dead, and just not knowing you're alive? Competence in physiology and chemistry."

/datum/stat/robustness
	name = STAT_ROB
	desc = "Violence is what people do when they run out of good ideas. Increases your health, damage in unarmed combat, affect the knockdown chance."

/datum/stat/toughness
	name = STAT_TGH
	desc = "You're a tough guy, but I'm a nightmare wrapped in the apocalypse. Enhances your resistance to poisons and also raises your speed in uncomfortable clothes."

/datum/stat/aiming
	name = STAT_VIG
	desc = "Here, paranoia is nothing but a useful trait. Improves your ability to control recoil on guns, helps you resist insanity."

// Use to perform stat checks
/mob/proc/stat_check(stat_path, needed)
	var/points = src.stats.getStat(stat_path)
	return points >= needed

/proc/statPointsToLevel(var/points)
	switch(points)
		if (STAT_LEVEL_NONE to STAT_LEVEL_BASIC)
			return "Untrained"
		if (STAT_LEVEL_BASIC to STAT_LEVEL_ADEPT)
			return "Basic"
		if (STAT_LEVEL_ADEPT to STAT_LEVEL_EXPERT)
			return "Adept"
		if (STAT_LEVEL_EXPERT to STAT_LEVEL_PROF)
			return "Expert"
		if (STAT_LEVEL_PROF to INFINITY)
			return "Master"
