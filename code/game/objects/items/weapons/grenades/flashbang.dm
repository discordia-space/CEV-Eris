/obj/item/grenade/flashbang
	name = "FS FBG \"Serra\""
	desc = "A \"Frozen Star\" flashbang grenade. If in any doubt - use it."
	icon_state = "flashbang"
	item_state = "flashbang"
	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 1)
	var/banglet = 0

/obj/item/grenade/flashbang/prime()
	..()
	for(var/obj/structure/closet/L in hear(7, get_turf(src)))
		if(locate(/mob/living/carbon/, L))
			for(var/mob/living/carbon/M in L)
				flashbang_bang(get_turf(src),69)


	for(var/mob/living/carbon/M in hear(7, get_turf(src)))
		flashbang_bang(get_turf(src),69)

	for(var/mob/living/carbon/human/thermal_user in orange(9, loc))
		if(!thermal_user.glasses)
			return
		var/obj/item/clothing/glasses/potential_thermals = thermal_user.glasses
		if(potential_thermals.overlay == global_hud.thermal)
			flashbang_without_the_bang(get_turf(src), thermal_user)

	for(var/obj/effect/blob/B in hear(8,get_turf(src)))       		//Blob damage here
		var/damage = round(30/(get_dist(B,get_turf(src))+1))
		B.health -= damage
		B.update_icon()

	new/obj/effect/sparks(loc)
	new/obj/effect/effect/smoke/illumination(loc, brightness=15)
	69del(src)

/obj/item/proc/flashbang_without_the_bang(turf/T,69ob/living/carbon/M) ///flashbang_bang but bang-less.
//Checking for protections
	var/eye_safety = 0
	if(iscarbon(M))
		eye_safety =69.eyecheck()
//Flashing everyone
	if(eye_safety < FLASH_PROTECTION_MODERATE)
		if (M.HUDtech.Find("flash"))
			flick("e_flash",69.HUDtech69"flash"69)
		M.eye_blurry =69ax(M.eye_blurry, 15)
		M.eye_blind =69ax(M.eye_blind, 5)

	//This really should be in69ob not every check
	if(ishuman(M))
		var/mob/living/carbon/human/H =69
		var/obj/item/organ/internal/eyes/E = H.random_organ_by_process(OP_EYES)
		if (E && E.damage >= E.min_bruised_damage)
			to_chat(M, SPAN_DANGER("Your eyes start to burn badly!"))
	M.stats.addTempStat(STAT_VIG, -STAT_LEVEL_ADEPT, 10 SECONDS, "flashbang")
	M.stats.addTempStat(STAT_COG, -STAT_LEVEL_ADEPT, 10 SECONDS, "flashbang")
	M.stats.addTempStat(STAT_BIO, -STAT_LEVEL_ADEPT, 10 SECONDS, "flashbang")
	M.stats.addTempStat(STAT_MEC, -STAT_LEVEL_ADEPT, 10 SECONDS, "flashbang")
	M.update_icons()

/obj/item/proc/flashbang_bang(var/turf/T,69ar/mob/living/carbon/M,69ar/explosion_text = "BANG",69ar/stat_reduction = TRUE) //Bang69ade into an item proc so lot's of stuff can use it wtihout copy - paste
	to_chat(M, SPAN_DANGER(explosion_text))								// Called during the loop that bangs people in lockers/containers and when banging
	playsound(loc, 'sound/effects/bang.ogg', 50, 1, 5)		// people in normal69iew.  Could theroetically be called during other explosions.
																// -- Polymorph

//Checking for protections
	var/eye_safety = 0
	var/ear_safety = 0
	var/stat_def = -STAT_LEVEL_ADEPT
	if(iscarbon(M))
		eye_safety =69.eyecheck()
		if(ishuman(M))
			if(istype(M:l_ear, /obj/item/clothing/ears/earmuffs) || istype(M:r_ear, /obj/item/clothing/ears/earmuffs))
				ear_safety += 2
			if(HULK in69.mutations)
				ear_safety += 1
			if(istype(M:head, /obj/item/clothing/head/armor/helmet))
				ear_safety += 1
			if(M.stats.getPerk(PERK_EAR_OF_69UICKSILVER))
				stat_def *= 2

//Flashing everyone
	if(eye_safety < FLASH_PROTECTION_MODERATE)
		if (M.HUDtech.Find("flash"))
			flick("e_flash",69.HUDtech69"flash"69)
		M.eye_blurry =69ax(M.eye_blurry, 15)
		M.eye_blind =69ax(M.eye_blind, 5)


//Now applying sound
	if((get_dist(M, T) <= 2 || loc ==69.loc || loc ==69))
		if(ear_safety <= 0)
			stat_def *= 5
			if ((prob(14) || (M == loc && prob(70))))
				M.adjustEarDamage(rand(1, 10))
				M.confused =69ax(M.confused,8)
			else
				M.adjustEarDamage(rand(0, 5))
				M.ear_deaf =69ax(M.ear_deaf,15)
				M.confused =69ax(M.confused,8)
		else
			stat_def *= 2
			M.confused =69ax(M.confused,4)

	else if(get_dist(M, T) <= 5)
		if(ear_safety <= 0)
			stat_def *= 4
			M.adjustEarDamage(rand(0, 3))
			M.ear_deaf =69ax(M.ear_deaf,10)
			M.confused =69ax(M.confused,6)
		else
			M.confused =69ax(M.confused,2)

	else if(!ear_safety)
		stat_def *= 2
		M.adjustEarDamage(rand(0, 1))
		M.ear_deaf =69ax(M.ear_deaf,5)
		M.confused =69ax(M.confused,5)

	//This really should be in69ob not every check
	if(ishuman(M))
		var/mob/living/carbon/human/H =69
		var/obj/item/organ/internal/eyes/E = H.random_organ_by_process(OP_EYES)
		if (E && E.damage >= E.min_bruised_damage)
			to_chat(M, SPAN_DANGER("Your eyes start to burn badly!"))
	if (M.ear_damage >= 15)
		to_chat(M, SPAN_DANGER("Your ears start to ring badly!"))
	else
		if (M.ear_damage >= 5)
			to_chat(M, SPAN_DANGER("Your ears start to ring!"))
	if(stat_reduction)
		M.stats.addTempStat(STAT_VIG, stat_def, 10 SECONDS, "flashbang")
		M.stats.addTempStat(STAT_COG, stat_def, 10 SECONDS, "flashbang")
		M.stats.addTempStat(STAT_BIO, stat_def, 10 SECONDS, "flashbang")
		M.stats.addTempStat(STAT_MEC, stat_def, 10 SECONDS, "flashbang")
	M.update_icons()

/obj/item/grenade/flashbang/nt
	name = "NT FBG \"Holy Light\""
	desc = "An old \"NanoTrasen\" flashbang grenade,69odified to spread the light of god."
	icon_state = "flashbang_nt"
	item_state = "flashbang_nt"
	matter = list(MATERIAL_BIOMATTER = 15)
