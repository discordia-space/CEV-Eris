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




/datum/stat/productivity
	name = STAT_PRD
	desc = "The world hadn’t ever had so many moving parts or so few labels. Character's ability in building and using various tools.."

/datum/stat/cognition
	name = STAT_COG
	desc = "Too many dots, not enough lines. Knowledge and ability to create new items."

/datum/stat/biology
	name = STAT_BIO
	desc = "What’s the difference between being dead, and just not knowing you’re alive? Competence in physiology and chemistry."

/datum/stat/physique
	name = STAT_PHY
	desc = "Violence is what people do when they run out of good ideas. Increases your health, damage in unarmed combat, affect the knockdown chance."

/datum/stat/robustness
	name = STAT_ROB
	desc = "You’re a tough guy, but I’m a nightmare wrapped in the apocalypse. Enhances your resistance to poisons and also raises your speed in uncomfortable clothes."

/datum/stat/agility
	name = STAT_AGI
	desc = "We see in order to move; we move in order to see. Affect the unarmed combat: increases your chances in hitting and disarming, enhances your grab speed."
