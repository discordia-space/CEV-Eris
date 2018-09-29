/datum/stat_holder
	var/list/stat_list = list()
	var/mob/living/host

/datum/stat_holder/New(var/mob/living/L)
	host = L
	for(var/sttype in subtypesof(/datum/stat))
		var/datum/stat/S = new sttype
		S.holder = src
		stat_list[S.name] = S

/datum/stat_holder/Destroy()
	for (var/a in stat_list)
		qdel(a)
	..()

//Sets all stats to zero cleanly
/datum/stat_holder/proc/zero()
	for (var/datum/stat/S in stat_list)
		if (S.value)
			S.changeValue(S.value*-1)

/datum/stat_holder/proc/addTempStat(statName, Value, timeDelay)
	var/datum/stat/S = stat_list[statName]
	S.addModif(timeDelay, Value)

/datum/stat_holder/proc/changeStat(statName, Value)
	var/datum/stat/S = stat_list[statName]
	S.changeValue(Value)

/datum/stat_holder/proc/getStat(statName, Pure = null)
	var/datum/stat/S = stat_list[statName]
	return S ? S.getValue(Pure) : -101




//Some helper procs for mobs, just wrappers to make things easier
/mob/proc/getStat(statName, Pure = null)
	if (!istype(src, /mob/living))
		return 0

	var/mob/living/L = src
	if (!L.stats)
		return 0

	return L.stats.getStat(statName, Pure)


/mob/proc/changeStat(statName, Pure = null)
	if (!istype(src, /mob/living))
		return 0

	var/mob/living/L = src
	if (!L.stats)
		return 0

	return L.stats.changeStat(statName, Pure)







//TODO: Throw away this half assed mod system once i port modifiers from aurora
/datum/stat_mod
	var/time = 0
	var/value = 0
	var/id

/datum/stat_mod/New(delay, affect)
	src.time = world.time + delay
	src.value = affect







/datum/stat
	var/name = "Character stat"
	var/desc = "Basic characteristic, you are not supposed to see this. Report to admins."
	var/value = STAT_VALUE_DEFAULT
	var/datum/stat_holder/holder
	var/list/mods

/datum/stat/New(var/datum/stat_holder/H)
	holder = H
	..()


/datum/stat/proc/addModif(delay, affect, id)
	for(var/elem in mods)
		var/datum/stat_mod/SM = elem
		if(SM.id == id)
			SM.time = world.time + delay
			SM.value = affect
			return
	mods += PoolOrNew(/datum/stat_mod, delay, affect)

/datum/stat/proc/changeValue(affect)
	value = value + affect

/datum/stat/proc/getValue(pure = FALSE)
	if(pure)
		return value
	else
		. = value
		for(var/elem in mods)
			var/datum/stat_mod/SM = elem
			if(SM.time > world.time)
				mods -= SM
				qdel(SM)
			. += SM.value




/datum/stat/productivity
	name = STAT_MEC
	desc = "The world hadn’t ever had so many moving parts or so few labels. Character's ability in building and using various tools.."

/datum/stat/cognition
	name = STAT_COG
	desc = "Too many dots, not enough lines. Knowledge and ability to create new items."

/datum/stat/biology
	name = STAT_BIO
	desc = "What’s the difference between being dead, and just not knowing you’re alive? Competence in physiology and chemistry."

/datum/stat/robustness
	name = STAT_ROB
	desc = "Violence is what people do when they run out of good ideas. Increases your strength, damage in unarmed combat, affect the knockdown chance."


//Toughness increases max health, by 1% per point
/datum/stat/toughness
	name = STAT_TGH
	desc = "You’re a tough guy, but I’m a nightmare wrapped in the apocalypse. Increases your health, enhances your resistance to poisons and also raises your speed in uncomfortable clothes."

/datum/stat/toughness/changeValue(delta)
	..(delta)
	holder.host.update_max_health() //Updating max health is handled in this function