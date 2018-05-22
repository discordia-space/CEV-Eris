/datum/stat_holder
	var/list/stat_list = list()

/datum/stat_holder/New()
	for(var/sttype in subtypesof(/datum/stat))
		var/datum/stat/S = new sttype
		stat_list[S.name] = S

/datum/stat_holder/proc/addTempStat(statName, Value, timeDelay)
	var/datum/stat/S = stat_list[statName]
	S.addModif(timeDelay, Value)

/datum/stat_holder/proc/changeStat(statName, Value)
	var/datum/stat/S = stat_list[statName]
	S.changeValue(Value)

/datum/stat_holder/proc/getStat(statName, Pure = null)
	var/datum/stat/S = stat_list[statName]
	return S ? S.getValue(Pure) : -101



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
	var/list/mods

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




/datum/stat/construction
	name = STAT_CNS
	desc = "Character's skill in building constructions and using various tools. Affects the speed and successfulness of wall dismantling, machinery designing."

/datum/stat/inventing
	name = STAT_INV
	desc = "Knowings and abilities in creating new items. The higher your skill — the more recipes you know. Also increases your crafting speed."

/datum/stat/biology
	name = STAT_BIO
	desc = "Competence in physiology and chemistry. Affects your surgery skill, increases efficiency of medkits."

/datum/stat/strength
	name = STAT_STR
	desc = "Increases your health, damage in unarmed combat, affects on knockdown chance."

/datum/stat/endurance
	name = STAT_END
	desc = "This characteristic increases your resistance to poisons and also boosts your speed in uncomfortable clothes."

/datum/stat/agility
	name = STAT_AGI
	desc = "Affects on unarmed combat: increases your chances in hitting and disarming, boosts your grab speed."
