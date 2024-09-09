/** Club's special Bonsai tree, so they can operate somewhat without a garden.

	Every 10 seconds, checks if it has 10+ units of any alcohol.
		If it does, removes said alcohol, and spawns a random base fruit or vegetable.
		Ratio, 10 alcohol: 1 produce.
**/

/obj/item/reagent_containers/bonsai
	name = "Laurelin bonsai"
	desc = "A small tree, gifted to the club by a previous patron. It subsists off of numerous alcohols, and produces fruits and vegetables in return."

	icon = 'icons/obj/bonsai.dmi'
	icon_state = "bonsai_1"
	layer = ABOVE_OBJ_LAYER
	w_class = ITEM_SIZE_NORMAL

	volume = 100 //Average bottle volume
	reagent_flags = OPENCONTAINER

	price_tag = 4000
	spawn_blacklisted = TRUE

	matter = list(MATERIAL_BIOMATTER = 50)
	origin_tech = list(TECH_BIO = 4)
	var/ticks

/obj/item/reagent_containers/bonsai/New()
	..()
	GLOB.all_faction_items[src] = GLOB.department_civilian
	START_PROCESSING(SSobj, src)
	icon_state = "bonsai_[rand(1, 4)]"
//make the bonsai a random color each round

/obj/item/reagent_containers/bonsai/Destroy()
	STOP_PROCESSING(SSobj, src)
	for(var/mob/living/carbon/human/H in viewers(get_turf(src)))
		SEND_SIGNAL_OLD(H, COMSIG_OBJ_FACTION_ITEM_DESTROY, src)
	GLOB.all_faction_items -= src
	..()

/obj/item/reagent_containers/bonsai/Process()
	if(++ticks % 10 == 0 && reagents.total_volume)
		var/reagent_count = 0
		for(var/datum/reagent/R in reagents.reagent_list)
			if(istype(R, /datum/reagent/alcohol))
				reagent_count += R.volume
				R.remove_self(R.volume)
		if(reagent_count > 10)
			var/amount_to_spawn = round(reagent_count/10)
			for(var/i = 0 to amount_to_spawn)
				var/datum/seed/S = plant_controller.seeds[pick(
					"tomato",
					"carrot",
					"corn",
					"eggplant",
					"chili",
					"mushroom",
					"wheat",
					"potato",
					"rice")]
				S.harvest(get_turf(src),0,0,1)
				flick(icon_state+"_animation", src)
				playsound(loc, 'sound/effects/ding2.ogg', 50, 1, -1)
