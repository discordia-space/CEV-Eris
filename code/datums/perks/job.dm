/datum/perk/inspiration
	name = "Exotic Inspiration"
	active = FALSE

/datum/perk/inspiration/activate()
	. = ..()
	if(!.)
		return
	holder.addTempStat(STAT_COG, 5, INFINITY, "Exotic Inspiration")
	holder.addTempStat(STAT_MEC, 10, INFINITY, "Exotic Inspiration")

/datum/perk/inspiration/deactivate()
	. = ..()
	if(!.)
		return
	holder.removeTempStat(STAT_COG, "Exotic Inspiration")
	holder.removeTempStat(STAT_MEC, "Exotic Inspiration")

/datum/perk/oyvey
	name = "Oy Vey"
	var/cooldown_time = 0
	active = FALSE
	toggleable = TRUE

/datum/perk/oyvey/activate()
	if(world.time < cooldown_time)
		return FALSE
	cooldown_time = world.time + 7 MINUTES
	addtimer(CALLBACK(src, .proc/deactivate), 1 MINUTES)
	return ..()
