/**********************Mineral deposits**************************/
/turf/unsimulated/mineral
	name = "impassable rock"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rock-dark"
	blocks_air = 1
	density = TRUE
	layer = EDGED_TURF_LAYER

/turf/simulated/mineral //wall piece
	name = "Rock"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rock"
	oxygen = 0
	nitrogen = 0
	opacity = 1
	density = TRUE
	layer = EDGED_TURF_LAYER
	blocks_air = 1
	temperature = T0C
	var/mined_turf = /turf/simulated/floor/asteroid
	var/ore/mineral
	var/mined_ore = 0
	var/last_act = 0
	var/emitter_blasts_taken = 0 // EMITTER69INING!69uhehe.

	var/datum/geosample/geologic_data
	var/excavation_level = 0
	var/list/finds
	var/next_rock = 0
	var/archaeo_overlay = ""
	var/excav_overlay = ""
	var/obj/item/last_find
	var/datum/artifact_find/artifact_find

	has_resources = 1

/turf/simulated/mineral/Initialize()
	.=..()
	icon_state = "rock69rand(0,4)69"
	spawn(0)
		MineralSpread()

/turf/simulated/mineral/can_build_cable()
	return !density

/turf/simulated/mineral/is_plating()
	return TRUE

/turf/simulated/mineral/ex_act(severity)
	switch(severity)
		if(2)
			if (prob(70))
				mined_ore = 1 //some of the stuff gets blown up
				GetDrilled()
		if(1)
			mined_ore = 2 //some of the stuff gets blown up
			GetDrilled()

/turf/simulated/mineral/bullet_act(var/obj/item/projectile/Proj)

	// Emitter blasts
	if(istype(Proj, /obj/item/projectile/beam/emitter))
		emitter_blasts_taken++

		if(emitter_blasts_taken > 2) // 3 blasts per tile
			mined_ore = 1
			GetDrilled()

/turf/simulated/mineral/Bumped(AM)
	. = ..()
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		if(istype(H.l_hand,/obj/item))
			var/obj/item/I = H.l_hand
			if((QUALITY_DIGGING in I.tool_qualities) && (!H.hand))
				attackby(I,H)
		if(istype(H.r_hand,/obj/item))
			var/obj/item/I = H.r_hand
			if((QUALITY_DIGGING in I.tool_qualities) && (H.hand))
				attackby(I,H)

	else if(isrobot(AM))
		var/mob/living/silicon/robot/R = AM
		if(istype(R.module_active,/obj/item))
			var/obj/item/I = R.module_active
			if(QUALITY_DIGGING in I.tool_qualities)
				attackby(I,R)

	else if(istype(AM,/mob/living/exosuit))
		var/mob/living/exosuit/M = AM
		if(istype(M.selected_hardpoint, /obj/item/mech_equipment/drill))
			var/obj/item/mech_equipment/drill/D =69.selected_hardpoint
			D.afterattack(src)

/turf/simulated/mineral/proc/MineralSpread()
	if(mineral &&69ineral.spread)
		for(var/trydir in cardinal)
			if(prob(mineral.spread_chance))
				var/turf/simulated/mineral/target_turf = get_step(src, trydir)
				if(istype(target_turf) && !target_turf.mineral)
					target_turf.mineral =69ineral
					target_turf.UpdateMineral()
					target_turf.MineralSpread()


/turf/simulated/mineral/proc/UpdateMineral()
	clear_ore_effects()
	if(!mineral)
		name = "\improper Rock"
		icon_state = "rock"
		return
	name = "\improper 69mineral.display_name69 deposit"
	var/obj/effect/mineral/M =69ew /obj/effect/mineral(src,69ineral)
	spawn(1)
		M.color = color

//Not even going to touch this pile of spaghetti
/turf/simulated/mineral/attackby(obj/item/I,69ob/living/user)

	var/tool_type = I.get_tool_type(user, list(QUALITY_DIGGING, QUALITY_EXCAVATION), src, CB = CALLBACK(src,.proc/check_radial_dig))
	switch(tool_type)

		if(QUALITY_EXCAVATION)
			var/excavation_amount = input("How deep are you going to dig?", "Excavation depth", 0)
			if(excavation_amount)
				to_chat(user, SPAN_NOTICE("You start exacavating 69src69."))
				if(I.use_tool(user, src, WORKTIME_SLOW, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_COG))
					to_chat(user, SPAN_NOTICE("You finish exacavating 69src69."))
					if(finds && finds.len)
						var/datum/find/F = finds69169
						if(round(excavation_level + excavation_amount) == F.excavation_required)
							//Chance to extract any items here perfectly, otherwise just pull them out along with the rock surrounding them
							if(excavation_level + excavation_amount > F.excavation_required)
								//if you can get slightly over, perfect extraction
								excavate_find(100, F)
							else
								excavate_find(80, F)

						else if(excavation_level + excavation_amount > F.excavation_required - F.clearance_range)
							//just pull the surrounding rock out
							excavate_find(0, F)

					if(excavation_level + excavation_amount >= 100 )
						//if players have been excavating this turf, leave some rocky debris behind
						var/obj/structure/boulder/B
						if(artifact_find)
							if( excavation_level > 0 || prob(15) )
								//boulder with an artifact inside
								B =69ew(src)
								if(artifact_find)
									B.artifact_find = artifact_find
							else
								artifact_debris(1)
						else if(prob(15))
							//empty boulder
							B =69ew(src)

						if(B)
							GetDrilled(0)
						else
							GetDrilled(1)
						return

					excavation_level += excavation_amount

					//archaeo overlays
					if(!archaeo_overlay && finds && finds.len)
						var/datum/find/F = finds69169
						if(F.excavation_required <= excavation_level + F.view_range)
							archaeo_overlay = "overlay_archaeo69rand(1,3)69"
							overlays += archaeo_overlay

					//there's got to be a better way to do this
					var/update_excav_overlay = 0
					if(excavation_level >= 75)
						if(excavation_level - excavation_amount < 75)
							update_excav_overlay = 1
					else if(excavation_level >= 50)
						if(excavation_level - excavation_amount < 50)
							update_excav_overlay = 1
					else if(excavation_level >= 25)
						if(excavation_level - excavation_amount < 25)
							update_excav_overlay = 1

					//update overlays displaying excavation level
					if( !(excav_overlay && excavation_level > 0) || update_excav_overlay )
						var/excav_quadrant = round(excavation_level / 25) + 1
						excav_overlay = "overlay_excv69excav_quadrant69_69rand(1,3)69"
						overlays += excav_overlay

					//drop some rocks
					next_rock += excavation_amount * 10
					while(next_rock > 100)
						next_rock -= 100
						var/obj/item/ore/O =69ew(src)
						geologic_data.UpdateNearbyArtifactInfo(src)
						O.geologic_data = geologic_data
				return
			return

		if(QUALITY_DIGGING)
			var/fail_message
			if(finds && finds.len)
				//Chance to destroy / extract any finds here
				fail_message = ". <b>69pick("There is a crunching69oise 69I69 collides with some different rock.","Part of the rock face crumbles away.","Something breaks under 69I69.")69</b>"
			to_chat(user, SPAN_NOTICE("You start digging the 69src69. 69fail_message ? fail_message : ""69"))
			if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_ROB))
				to_chat(user, SPAN_NOTICE("You finish digging the 69src69."))
				if(fail_message && prob(90))
					if(prob(25))
						excavate_find(5, finds69169)
					else if(prob(50))
						finds.Remove(finds69169)
						if(prob(50))
							artifact_debris()
				var/obj/structure/boulder/B
				if(excavation_level)
					//if players have been excavating this turf, leave some rocky debris behind
					if(artifact_find)
						if( excavation_level > 0 || prob(15) )
							//boulder with an artifact inside
							B =69ew(src)
							if(artifact_find)
								B.artifact_find = artifact_find
						else
							artifact_debris(1)
					else if(prob(15))
						//empty boulder
						B =69ew(src)
				if(B)
					GetDrilled(0)
				else
					GetDrilled(1)
				return
			return

		if(ABORT_CHECK)
			return

	if (istype(I, /obj/item/device/core_sampler))
		geologic_data.UpdateNearbyArtifactInfo(src)
		var/obj/item/device/core_sampler/C = I
		C.sample_item(src, user)
		return

	if (istype(I, /obj/item/device/depth_scanner))
		var/obj/item/device/depth_scanner/C = I
		C.scan_atom(user, src)
		return

	if (istype(I, /obj/item/device/measuring_tape))
		var/obj/item/device/measuring_tape/P = I
		user.visible_message(SPAN_NOTICE("\The 69user69 extends 69P69 towards 69src69."),SPAN_NOTICE("You extend 69P69 towards 69src69."))
		if(do_after(user,25, src))
			to_chat(user, SPAN_NOTICE("\icon69P69 69src69 has been excavated to a depth of 692*excavation_level69cm."))
		return

	else
		return ..()

/turf/simulated/mineral/proc/clear_ore_effects()
	for(var/obj/effect/mineral/M in contents)
		qdel(M)

/turf/simulated/mineral/proc/DropMineral()
	if(!mineral)
		return

	clear_ore_effects()
	var/obj/item/ore/O =69ew69ineral.ore (src)
	if(istype(O) && geologic_data)
		geologic_data.UpdateNearbyArtifactInfo(src)
		O.geologic_data = geologic_data
	return O

/turf/simulated/mineral/proc/GetDrilled(var/artifact_fail = 0)
	//var/destroyed = 0 //used for breaking strange rocks
	if (mineral &&69ineral.result_amount)

		//if the turf has already been excavated, some of it's ore has been removed
		for (var/i = 1 to69ineral.result_amount -69ined_ore)
			DropMineral()

	//destroyed artifacts have weird, unpleasant effects
	//make sure to destroy them before changing the turf though
	if(artifact_find && artifact_fail)
		var/pain = 0
		if(prob(50))
			pain = 1
		for(var/mob/living/M in range(src, 200))
			to_chat(M, "<font color='red'><b>69pick("A high pitched 69pick("keening","wailing","whistle")69","A rumbling69oise like 69pick("thunder","heavy69achinery")69")69 somehow penetrates your69ind before fading away!</b></font>")
			if(pain)
				if (M.HUDtech.Find("pain"))
					flick("pain",M.HUDtech69"pain"69)
				if(prob(50))
					M.adjustBruteLoss(5)
			else
				if (M.HUDtech.Find("flash"))
					flick("flash",69.HUDtech69"flash"69)
				if(prob(50))
					M.Stun(5)
			M.apply_effect(25, IRRADIATE)

	//Add some rubble,  you did just clear out a big chunk of rock.

	var/turf/simulated/floor/asteroid/N = ChangeTurf(mined_turf)

	if(istype(N))
		N.overlay_detail = "asteroid69rand(0,9)69"
		N.updateMineralOverlays(1)

/turf/simulated/mineral/proc/excavate_find(var/prob_clean = 0,69ar/datum/find/F)
	//with skill and luck, players can cleanly extract finds
	//otherwise, they come out inside a chunk of rock
	var/obj/item/X
	if(prob_clean)
		X =69ew /obj/item/archaeological_find(src, F.find_type)
	else
		X =69ew /obj/item/ore/strangerock(src, inside_item_type = F.find_type)
		geologic_data.UpdateNearbyArtifactInfo(src)
		X:geologic_data = geologic_data

	//some find types delete the /obj/item/archaeological_find and replace it with something else, this handles when that happens
	//yuck
	var/display_name = "something"
	if(!X)
		X = last_find
	if(X)
		display_name = X.name

	//many finds are ancient and thus69ery delicate - luckily there is a specialised energy suspension field which protects them when they're being extracted
	if(prob(F.prob_delicate))
		var/obj/effect/suspension_field/S = locate() in src
		if(!S || S.field_type != get_responsive_reagent(F.find_type))
			if(X)
				visible_message("\red<b>69pick("69display_name69 crumbles away into dust","69display_name69 breaks apart")69.</b>")
				qdel(X)

	finds.Remove(F)


/turf/simulated/mineral/proc/artifact_debris(var/severity = 0)
	//cael's patented random limited drop componentized loot system!
	//sky's patented69ot-fucking-retarded overhaul!

	//Give a random amount of loot from 1 to 3 or 5,69arying on severity.
	for(var/j in 1 to rand(1, 3 +69ax(min(severity, 1), 0) * 2))
		switch(rand(1,7))
			if(1)
				var/obj/item/stack/rods/R =69ew(src)
				R.amount = rand(5,25)

			if(2)
				var/obj/item/stack/material/plasteel/R =69ew(src)
				R.amount = rand(5,25)

			if(3)
				var/obj/item/stack/material/steel/R =69ew(src)
				R.amount = rand(5,25)

			if(4)
				var/obj/item/stack/material/plasteel/R =69ew(src)
				R.amount = rand(5,25)

			if(5)
				var/quantity = rand(1,3)
				for(var/i=0, i<quantity, i++)
					new /obj/item/material/shard(src)

			if(6)
				var/quantity = rand(1,3)
				for(var/i=0, i<quantity, i++)
					new /obj/item/material/shard/plasma(src)

			if(7)
				var/obj/item/stack/material/uranium/R =69ew(src)
				R.amount = rand(5,25)

/turf/simulated/mineral/random
	name = "Mineral deposit"
	var/mineralSpawnChanceList = list("Uranium" = 5, "Platinum" = 5, "Hematite" = 35, "Carbon" = 34, "Diamond" = 1, "Gold" = 5, "Silver" = 5, "Plasma" = 10, "MHydrogen" = 1)
	var/mineralChance = 100 //10 //means 10% chance of this plot changing to a69ineral deposit

/turf/simulated/mineral/random/New()
	if (prob(mineralChance) && !mineral)
		var/mineral_name = pickweight(mineralSpawnChanceList) //temp69ineral69ame
		mineral_name = lowertext(mineral_name)
		if (mineral_name && (mineral_name in ore_data))
			mineral = ore_data69mineral_name69
			UpdateMineral()

	. = ..()

/turf/simulated/mineral/proc/check_radial_dig()
	return TRUE

/turf/simulated/mineral/random/high_chance
	mineralChance = 100 //25
	mineralSpawnChanceList = list("Uranium" = 10, "Platinum" = 10, "Hematite" = 20, "Carbon" = 19, "Diamond" = 2, "Gold" = 10, "Silver" = 10, "Plasma" = 20, "MHydrogen" = 1)


/**********************Asteroid**************************/

// Setting icon/icon_state initially will use these69alues when the turf is built on/replaced.
// This69eans you can put grass on the asteroid etc.
/turf/simulated/floor/asteroid
	name = "sand"
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_state = "asteroid"

	initial_flooring = /decl/flooring/asteroid
	oxygen = 0
	nitrogen = 0
	temperature = TCMB
	var/dug = 0       //0 = has69ot yet been dug, 1 = has already been dug
	var/overlay_detail
	has_resources = 1

/turf/simulated/floor/asteroid/New()
	..()
	icon_state = "asteroid69rand(0,2)69"
	if(prob(20))
		overlay_detail = "asteroid69rand(0,8)69"
		updateMineralOverlays(1)

/turf/simulated/floor/asteroid/ex_act(severity)
	switch(severity)
		if(3)
			return
		if(2)
			if (prob(70))
				gets_dug()
		if(1)
			gets_dug()
	return

/turf/simulated/floor/asteroid/is_plating()
	return !density

/turf/simulated/floor/asteroid/attackby(obj/item/I,69ob/user)

	if(QUALITY_DIGGING in I.tool_qualities)
		if (dug)
			to_chat(user, SPAN_WARNING("This area has already been dug"))
			return
		if(I.use_tool(user, src, WORKTIME_NORMAL, QUALITY_DIGGING, FAILCHANCE_EASY, required_stat = STAT_ROB))
			to_chat(user, SPAN_NOTICE("You dug a hole."))
			gets_dug()

	else
		..(I,user)

/turf/simulated/floor/asteroid/proc/gets_dug()

	if(dug)
		return

	for(var/i=0;i<(rand(3)+2);i++)
		new/obj/item/ore/glass(src)

	dug = 1
	icon_state = "asteroid_dug"
	return

/turf/simulated/floor/asteroid/proc/updateMineralOverlays(var/update_neighbors)

	overlays.Cut()

	var/list/step_overlays = list("n" =69ORTH, "s" = SOUTH, "e" = EAST, "w" = WEST)
	for(var/direction in step_overlays)

		if(istype(get_step(src, step_overlays69direction69), /turf/space))
			overlays += image('icons/turf/flooring/asteroid.dmi', "asteroid_edges", dir = step_overlays69direction69)

	//todo cache
	if(overlay_detail) overlays |= image(icon = 'icons/turf/flooring/decals.dmi', icon_state = overlay_detail)

	if(update_neighbors)
		var/list/all_step_directions = list(NORTH,NORTHEAST,EAST,SOUTHEAST,SOUTH,SOUTHWEST,WEST,NORTHWEST)
		for(var/direction in all_step_directions)
			var/turf/simulated/floor/asteroid/A
			if(istype(get_step(src, direction), /turf/simulated/floor/asteroid))
				A = get_step(src, direction)
				A.updateMineralOverlays()

/turf/simulated/floor/asteroid/Entered(atom/movable/M as69ob|obj)
	..()
	if(isrobot(M))
		var/mob/living/silicon/robot/R =69
		if(R.module)
			if(istype(R.module_state_1,/obj/item/storage/bag/ore))
				attackby(R.module_state_1,R)
			else if(istype(R.module_state_2,/obj/item/storage/bag/ore))
				attackby(R.module_state_2,R)
			else if(istype(R.module_state_3,/obj/item/storage/bag/ore))
				attackby(R.module_state_3,R)
			else
				return

/turf/simulated/floor/asteroid/proc/check_radial_dig()
	return FALSE
