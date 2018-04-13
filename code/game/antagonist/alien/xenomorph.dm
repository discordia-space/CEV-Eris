/datum/antagonist/xenos
	id = ROLE_XENOMORPH
	role_text = "Xenomorph"
	role_text_plural = "Xenomorphs"
	mob_path = /mob/living/carbon/alien/larva
	bantype = "Xenomorph"
	welcome_text = "Hiss! You are a larval alien. Hide and bide your time until you are ready to evolve."
	faction_type = /datum/faction/xenomorph
	outer = TRUE

/datum/antagonist/xenos/proc/get_vents()
	var/list/vents = list()
	for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in SSmachines.machinery)
		if(!temp_vent.welded && temp_vent.network && temp_vent.loc.z in config.station_levels)
			if(temp_vent.network.normal_members.len > 50)
				vents += temp_vent
	return vents

/datum/antagonist/xenos/create_objectives(var/datum/mind/player)
	if(!..())
		return
	new /datum/objective/survive (player)

/datum/antagonist/xenos/place_antagonist(var/mob/living/player)
	player.forceMove(get_turf(pick(get_vents())))
