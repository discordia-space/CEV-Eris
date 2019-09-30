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

/datum/perk/intimidation
	name = ""
	var/last_message = 0
	var/message_cooldown = 10 MINUTES
	var/list/stats_to_debuff = list()

/datum/perk/intimidation/New()
	. = ..()
	START_PROCESSING(SSprocessing, src)

/datum/perk/intimidation/Destroy()
	. = ..()
	STOP_PROCESSING(SSprocessing, src)

/datum/perk/intimidation/activate()
	. = ..()
	if(!.)
		return
	START_PROCESSING(SSprocessing, src)
	

/datum/perk/intimidation/deactivate()
	. = ..()
	if(!.)
		return
	STOP_PROCESSING(SSprocessing, src)

/datum/perk/intimidation/Process()
	if(istype(holder.assigned_mob, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = holder.assigned_mob
		if(H.is_face_covered())
			return

	var/show_message = FALSE
	if(last_message + message_cooldown <= world.time)
		last_message = world.time
		show_message = TRUE
	
	var/list/mob/targets = mobs_in_view(world.view, holder.assigned_mob)
	targets.Remove(holder.assigned_mob)
	for(var/mob/M in targets)
		for(var/stat_name in stats_to_debuff)
			M.stats.addTempStat(stat_name, M.has_perk(/datum/perk/military_training) ? (stats_to_debuff[stat_name]/2) : stats_to_debuff[stat_name], BUFF_TIME, "[name] of [holder.assigned_mob]")
	if(show_message)
		if(prob(75))	// some chance to remove steady messages
			holder.assigned_mob.visible_message(SPAN_WARNING("[holder.assigned_mob] looks [pick(list("scary","terrifying","unsettling"))]."), "", range = 4)

/datum/perk/intimidation/menacing_presence
	name = "Menacing Presence"
	stats_to_debuff = list(STAT_VIG = 10, STAT_ROB = 10, STAT_TGH = 10)

/datum/perk/military_training
	name = "Military Training"