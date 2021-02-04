/datum/ritual/cruciform/agrolyte
	name = "agrolyte"
	phrase = null
	desc = ""
	category = "Agrolyte"

/datum/ritual/cruciform/agrolyte/accelerated_growth
	name = "Accelerated growth ritual"
	phrase = "Plantae crescere in divinum lumen tua"
	desc = "This litany boosts the growth of all plants in sight for about ten minutes. "
	cooldown = TRUE
	cooldown_time = 5 MINUTES
	effect_time = 5 MINUTES
	cooldown_category = "accelerated_growth"
	power = 50

	var/boost_value = 1.5  // How much the aging process of the plant is sped up

/datum/ritual/cruciform/agrolyte/accelerated_growth/perform(mob/living/carbon/human/user, obj/item/weapon/implant/core_implant/C)

	var/list/plants_around = list()
	for(var/obj/machinery/portable_atmospherics/hydroponics/H in view(user))
		if(H.seed)  // if there is a plant in the hydroponics tray
			plants_around.Add(H.seed)

	if(plants_around.len > 0)
		to_chat(user, SPAN_NOTICE("You feel the air thrum with an inaudible vibration."))
		playsound(user.loc, 'sound/machines/signal.ogg', 50, 1)
		for(var/datum/seed/S in plants_around)
			give_boost(S)
		set_global_cooldown()
		return TRUE
	else
		fail("There is no plant around to hear your song.", user, C)
		return FALSE

/datum/ritual/cruciform/agrolyte/accelerated_growth/proc/give_boost(datum/seed/S)
	S.set_trait(TRAIT_BOOSTED_GROWTH, boost_value)
	addtimer(CALLBACK(src, .proc/take_boost, S), effect_time)

/datum/ritual/cruciform/agrolyte/accelerated_growth/proc/take_boost(datum/seed/S, stat, amount)
	// take_boost is automatically triggered by a callback function when the boost ends but the seed 
	// may have been deleted during the duration of the boost
	if (S) // check if seed still exist otherwise we cannot read null.stats
		S.set_trait(TRAIT_BOOSTED_GROWTH, 1)
