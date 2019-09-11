/datum/background
	var/name = "None"
	var/category = ""
	var/desc = ""
	var/restricted_depts = 0          //department_flag
	var/list/restricted_jobs = list() //job paths
	var/list/allowed_jobs = list()    //same as above
	var/list/stat_modifiers = list()  //STAT = number
	var/list/perks = list()           //perk paths

/datum/background/New()
	. = ..()
	for(var/job in joblist)
		var/datum/job/J = joblist[job]
		if(J.department_flag & restricted_depts)
			restricted_jobs |= J.type

/datum/background/proc/apply(mob/living/carbon/human/character)
	for(var/stat in src.stat_modifiers)
		character.stats.changeStat(stat, stat_modifiers[stat])
	for(var/perk in src.perks)
		var/datum/perk/P = new perk
		P.teach(character)
