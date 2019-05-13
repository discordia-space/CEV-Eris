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
	if (!islist(statName))
		var/datum/stat/S = stat_list[statName]
		return S ? S.getValue(Pure) : 0
	else
		/*
			Passing a list to getStat allows you to do some fancy compound behaviour
			Check the other mob_stats define file for the defines used here
		*/
		var/list/request = statName
		var/combine_type = request[1]

		var/list/values = list()

		//Lets get the values of the stats involved
		//We loop through the list starting from 2, since element 1 is a define telling us how to combine values
		for (var/i = 2; i <= request.len;i++)
			var/datum/stat/S = stat_list[request[i]]
			values.Add(S ? S.getValue(Pure) : 0)

		//Now we've got the values, what do we do with them?
		switch (combine_type)
			if (STAT_MAX)
				var/highest = -INFINITY
				for (var/a in values)
					if (a > highest)
						highest = a
				return highest
			if (STAT_MIN)
				var/lowest = INFINITY
				for (var/a in values)
					if (a < lowest)
						lowest = a
				return lowest

			if (STAT_SUM)
				var/total = 0
				for (var/a in values)
					total += a
				return total

			if (STAT_AVG)
				var/total = 0
				for (var/a in values)
					total += a
				return total / values.len

			else
				return 0

/datum/stat_holder/proc/Clone()
	var/datum/stat_holder/new_stat = new()
	for (var/S in stat_list)
		new_stat.changeStat(S, src.getStat(S))
	return new_stat

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
	mods += new /datum/stat_mod(delay, affect)

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
	desc = "The world hadn't ever had so many moving parts or so few labels. Character's ability in building and using various tools.."

/datum/stat/cognition
	name = STAT_COG
	desc = "Too many dots, not enough lines. Knowledge and ability to create new items."

/datum/stat/biology
	name = STAT_BIO
	desc = "What's the difference between being dead, and just not knowing you're alive? Competence in physiology and chemistry."

/datum/stat/physique
	name = STAT_ROB
	desc = "Violence is what people do when they run out of good ideas. Increases your health, damage in unarmed combat, affect the knockdown chance."

/datum/stat/robustness
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
