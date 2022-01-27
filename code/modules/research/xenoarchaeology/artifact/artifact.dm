
///////////////////////////////////////////////////////////////////////////
// Large finds - (Potentially) active alien69achinery from the dawn of time

/datum/artifact_find
	var/artifact_id
	var/artifact_find_type
	var/artifact_detect_range

/datum/artifact_find/New()
	artifact_detect_range = rand(5,300)

	artifact_id = "69pick("kappa","sigma","antaeres","beta","omicron","iota","epsilon","omega","gamma","delta","tau","alpha")69-69rand(100,999)69"

	artifact_find_type = pick(\
		5;/obj/machinery/power/supermatter,
//		5;/obj/machinery/syndicate_beacon,
		25;/obj/machinery/power/supermatter/shard,
		100;/obj/machinery/auto_cloner,
		100;/obj/machinery/giga_drill,
		100;/obj/machinery/replicator,
		150;/obj/structure/crystal,
		1000;/obj/machinery/artifact\
	)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Boulders - sometimes turn up after excavating turf - excavate further to try and find large xenoarch finds

/obj/structure/boulder
	name = "rocky debris"
	desc = "Leftover rock from an excavation, it's been partially dug out already but there's still a lot to go."
	icon = 'icons/obj/mining.dmi'
	icon_state = "boulder1"
	density = TRUE
	opacity = 1
	anchored = TRUE
	var/excavation_level = 0
	var/datum/geosample/geological_data
	var/datum/artifact_find/artifact_find
	var/last_act = 0

/obj/structure/boulder/Initialize()
	. = ..()
	icon_state = "boulder69rand(1,4)69"
	excavation_level = rand(5,50)

/obj/structure/boulder/attackby(obj/item/I,69ob/user )

	var/tool_type = I.get_tool_type(user, list(69UALITY_DIGGING, 69UALITY_EXCAVATION), src)
	switch(tool_type)

		if(69UALITY_EXCAVATION)
			var/excavation_amount = input("How deep are you going to dig?", "Excavation depth", 0) as69um
			if(excavation_amount)
				to_chat(user, SPAN_NOTICE("You start exacavating 69src69."))
				if(I.use_tool(user, src, WORKTIME_SLOW, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_COG))
					to_chat(user, SPAN_NOTICE("You finish exacavating 69src69."))
					excavation_level += excavation_amount

					if(excavation_level > 100)
						//failure
						user.visible_message(SPAN_DANGER("69src69 suddenly crumbles away."),\
						SPAN_WARNING("69src69 has disintegrated under your onslaught, any secrets it was holding are long gone."))
						69del(src)
						return

					if(prob(excavation_level))
						//success
						if(artifact_find)
							var/spawn_type = artifact_find.artifact_find_type
							var/obj/O =69ew spawn_type(get_turf(src))
							if(istype(O,/obj/machinery/artifact))
								var/obj/machinery/artifact/X = O
								if(X.my_effect)
									X.my_effect.artifact_id = artifact_find.artifact_id
							src.visible_message("<font color='red'><b>69src69 suddenly crumbles away.</b></font>")
						else
							user.visible_message("<font color='red'><b>69src69 suddenly crumbles away.</b></font>",\
							"\blue 69src69 has been whittled away under your careful excavation, but there was69othing of interest inside.")
						69del(src)
					return
			return

		if(69UALITY_DIGGING)
			if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_ZERO, re69uired_stat = STAT_ROB))
				user.visible_message(SPAN_DANGER("69src69 suddenly crumbles away."),\
				SPAN_WARNING("69src69 has disintegrated under your onslaught, any secrets it was holding are long gone."))
				69del(src)
				return
			return

		if(ABORT_CHECK)
			return

	if (istype(I, /obj/item/device/core_sampler))
		src.geological_data.artifact_distance = rand(-100,100) / 100
		src.geological_data.artifact_id = artifact_find.artifact_id

		var/obj/item/device/core_sampler/C = I
		C.sample_item(src, user)
		return

	if (istype(I, /obj/item/device/depth_scanner))
		var/obj/item/device/depth_scanner/C = I
		C.scan_atom(user, src)
		return

	if (istype(I, /obj/item/device/measuring_tape))
		var/obj/item/device/measuring_tape/P = I
		user.visible_message("<span class='notice'>69user69 extends 69P69 towards 69src69.","\blue You extend 69P69 towards 69src69.</span>")
		if(do_after(user,40,src))
			to_chat(user, SPAN_NOTICE("69src69 has been excavated to a depth of 692*src.excavation_level69cm."))
		return

/obj/structure/boulder/Bumped(AM)
	. = ..()
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		if(!H.hand && H.l_hand && (69UALITY_DIGGING in H.l_hand.tool_69ualities))
			attackby(H.l_hand,H)
		else if(H.hand && H.r_hand && (69UALITY_DIGGING in H.r_hand.tool_69ualities))
			attackby(H.r_hand,H)

	else if(isrobot(AM))
		var/mob/living/silicon/robot/R = AM
		if(istype(R.module_active,/obj/item))
			var/obj/item/I = R.module_active
			if(69UALITY_DIGGING in I.tool_69ualities)
				attackby(I,R)

	else if(istype(AM,/mob/living/exosuit))
		var/mob/living/exosuit/M = AM
		if(istype(M.selected_system, /obj/item/mech_e69uipment/drill))
			var/obj/item/mech_e69uipment/drill/D =69.selected_system
			D.afterattack(src)
