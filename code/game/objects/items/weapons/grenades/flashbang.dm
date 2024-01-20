/obj/item/grenade/flashbang
	name = "FS FBG \"Serra\""
	desc = "A \"Frozen Star\" flashbang grenade. If in any doubt - use it."
	description_info = "Will stun anyone using thermals from double the distance for a normal person, through walls"
	icon_state = "flashbang"
	item_state = "flashbang"
	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 1)
	var/banglet = 0
	matter = list(MATERIAL_STEEL = 2, MATERIAL_SILVER = 1)

/obj/item/grenade/flashbang/prime()
	..()
	for(var/obj/structure/closet/L in hear(7, get_turf(src)))
		if(locate(/mob/living/carbon/, L))
			for(var/mob/living/carbon/M in L)
				flashbang_bang(get_turf(src), M)


	for(var/mob/living/carbon/M in hear(7, get_turf(src)))
		flashbang_bang(get_turf(src), M)

	for(var/mob/living/carbon/human/thermal_user in orange(9, loc))
		if(!thermal_user.glasses)
			return
		var/obj/item/clothing/glasses/potential_thermals = thermal_user.glasses
		if(potential_thermals.overlay == global_hud.thermal)
			flashbang_without_the_bang(get_turf(src), thermal_user)

	for(var/obj/effect/blob/B in hear(8,get_turf(src)))	//Blob damage here
		var/damage = round(30/(get_dist(B,get_turf(src))+1))
		B.health -= damage
		B.update_icon()

	new/obj/effect/sparks(loc)
	new/obj/effect/effect/smoke/illumination(loc, brightness=15)
	qdel(src)

/obj/item/proc/flashbang_without_the_bang(turf/T, mob/living/carbon/M) //Flashbang_bang but bang-less.
	//This really should be in mob not every check
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.flash(3, FALSE , TRUE , TRUE, 15)
	else
		M.flash(5, FALSE, TRUE , TRUE)
	M.stats.addTempStat(STAT_VIG, -STAT_LEVEL_ADEPT, 10 SECONDS, "flashbang")
	M.stats.addTempStat(STAT_COG, -STAT_LEVEL_ADEPT, 10 SECONDS, "flashbang")
	M.stats.addTempStat(STAT_BIO, -STAT_LEVEL_ADEPT, 10 SECONDS, "flashbang")
	M.stats.addTempStat(STAT_MEC, -STAT_LEVEL_ADEPT, 10 SECONDS, "flashbang")
	M.update_icons()

/obj/item/proc/flashbang_bang(var/turf/T, var/mob/living/carbon/M, var/explosion_text = "BANG", var/stat_reduction = TRUE, var/intensity = FALSE) //Bang made into an item proc so lot's of stuff can use it wtihout copy - paste
	to_chat(M, SPAN_DANGER(explosion_text))								// Called during the loop that bangs people in lockers/containers and when banging
	playsound(loc, 'sound/effects/bang.ogg', 50, 1, 5)		// people in normal view.  Could theroetically be called during other explosions.
																// -- Polymorph

//Checking for protections
	var/eye_safety = 0
	var/ear_safety = 0
	var/stat_def = -STAT_LEVEL_ADEPT
	if(iscarbon(M))
		eye_safety = M.eyecheck()
		if(ishuman(M))
			ear_safety = M.earcheck()
			if(M.stats.getPerk(PERK_EAR_OF_QUICKSILVER))
				stat_def *= 2
	if(intensity)
		eye_safety += 1

//Flashing everyone
	if(eye_safety < FLASH_PROTECTION_MAJOR)
		M.flash(3, FALSE , TRUE , TRUE , 15 - (15*eye_safety))

//Now applying sound
	var/flash_distance
	var/bang_intensity

	if(loc == M.loc || loc == M)
		flash_distance = 0
	else
		flash_distance = get_dist(M, T) + ear_safety

	switch(flash_distance)
		if(-INFINITY to 3)
			bang_intensity = 1
		if(3 to 6)
			bang_intensity = 2
		if(6 to INFINITY)
			bang_intensity = 3

	if(intensity)
		bang_intensity += intensity

	switch(bang_intensity)
		if(1)
			if(ear_safety <= 0)
				stat_def *= 5
				if ((prob(14) || (M == loc && prob(70))))
					M.adjustEarDamage(rand(1, 10))
					M.confused = max(M.confused,8)
				else
					M.adjustEarDamage(rand(0, 5))
					M.ear_deaf = max(M.ear_deaf,15)
					M.confused = max(M.confused,8)
			else
				stat_def *= 2
				M.confused = max(M.confused,4)
		if(2)
			if(ear_safety <= 0)
				stat_def *= 4
				M.adjustEarDamage(rand(0, 3))
				M.ear_deaf = max(M.ear_deaf,10)
				M.confused = max(M.confused,6)
			else
				M.confused = max(M.confused,2)
		if(3)
			stat_def *= 2
			M.adjustEarDamage(rand(0, 1))
			M.ear_deaf = max(M.ear_deaf,5)
			M.confused = max(M.confused,5)

	//This really should be in mob not every check
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
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
	desc = "An old \"NanoTrasen\" flashbang grenade. \
			There\'s an inscription along the bands. \'Rome will glow with the light of her Lord.\'"
	icon_state = "flashbang_nt"
	item_state = "flashbang_nt"
	matter = list(MATERIAL_BIOMATTER = 15)

/obj/item/grenade/flashbang/nt/flashbang_without_the_bang(turf/T, mob/living/carbon/M)
	if(M.get_core_implant(/obj/item/implant/core_implant/cruciform))
		to_chat(M, span_singing("You are blinded by the Angels\' light!"))
		M.flash(0, FALSE, FALSE , FALSE, 0) // angel light , non-harmfull other than the overlay
		return
	..()

/obj/item/grenade/flashbang/nt/flashbang_bang(var/turf/T, var/mob/living/carbon/M, var/explosion_text = "BANG", var/stat_reduction = TRUE, var/intensity = FALSE)
	if(M.get_core_implant(/obj/item/implant/core_implant/cruciform))
		intensity += 1
	..()
