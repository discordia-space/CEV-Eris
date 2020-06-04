/*
Boss of this maints.
Has ability of every roach.
*/

/mob/living/carbon/superior_animal/roach/kaiser
	name = "Kaiser Roach"
	desc = "A glorious emperor of roaches."
	icon = 'icons/mob/64x64.dmi'
	icon_state = "kaiser_roach"
	pixel_x = -16
	density = TRUE

	turns_per_move = 4
	maxHealth = 2000
	health = 2000
	contaminant_immunity = TRUE

	var/datum/reagents/gas_sac

	melee_damage_lower = 10
	melee_damage_upper = 20
	move_to_delay = 8
	mob_size =  3  // The same as Hivemind Tyrant

	var/distress_call_stage = 3

	// TODO: Make Kaiser call reinforcements only when he achieves one of health markers
	var/health_marker_1 = 1500
	var/health_marker_2 = 1000
	var/health_marker_3 = 500

	blattedin_revives_left = 0 // Kaiser is a giant roach, there is no way to revive him

	// TODO: Add a special type of meat for Kaiser
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat/roachmeat/fuhrer
	meat_amount = 15
	sanity_damage = 3

/mob/living/carbon/superior_animal/roach/kaiser/New()
	..()
	gas_sac = new /datum/reagents(100, src)

/mob/living/carbon/superior_animal/roach/kaiser/Life()
	. = ..()
	if(stat != CONSCIOUS)
		return

	if(stat != AI_inactive)
		return
	
	// TODO: Make this part of code work and don't look like piece of shit.
	if(health_marker_1 >= health > health_marker_2 && distress_call_stage == 3)
		log_and_message_admins("HERE HERE HERE HERE")
		distress_call()
	if(health_marker_2 >= health > health_marker_3 && distress_call_stage == 2)
		distress_call()
	if(health_marker_3 >= health > 0 && distress_call_stage == 1)
		distress_call()

	gas_sac.add_reagent("blattedin", 1)
	if(prob(7))
		gas_attack()


// TOXIC ABILITIES
/mob/living/carbon/superior_animal/roach/kaiser/UnarmedAttack(atom/A, proximity)
	. = ..()

	if(isliving(A))
		var/mob/living/L = A
		if(istype(L) && prob(10))
			var/damage = rand(melee_damage_lower, melee_damage_upper)
			L.adjustToxLoss(damage)
			playsound(src, 'sound/voice/insect_battle_screeching.ogg', 30, 1, -3)
			L.visible_message(SPAN_DANGER("\the [src] globs up some toxic bile all over \the [L]!"))

// SUPPORT ABILITIES
/mob/living/carbon/superior_animal/roach/kaiser/proc/gas_attack()
	if (!gas_sac.has_reagent("blattedin", 20) || stat != CONSCIOUS)
		return

	var/location = get_turf(src)
	var/datum/effect/effect/system/smoke_spread/chem/S = new

	S.attach(location)
	S.set_up(gas_sac, gas_sac.total_volume, 0, location)
	src.visible_message(SPAN_DANGER("\the [src] secretes strange vapors!"))

	spawn(0)
		S.start()

	gas_sac.clear_reagents()
	return 1

/mob/living/carbon/superior_animal/roach/support/findTarget()
	. = ..()
	if(. && gas_attack())
		visible_emote("charges at [.] in clouds of poison!")

// FUHRER ABILITIES
/mob/living/carbon/superior_animal/roach/kaiser/proc/distress_call()
	if (!distress_call_stage)
		return

	for (var/mob/living/carbon/human/H in view())
		if (H.stat != DEAD && H.client)
			break

	if (distress_call_stage)
		distress_call_stage--
		playsound(src.loc, 'sound/voice/shriek1.ogg', 100, 1, 8, 8)
		spawn(2)
			playsound(src.loc, 'sound/voice/shriek1.ogg', 100, 1, 8, 8)
			//Playing the sound twice will make it sound really horrible

		visible_message(SPAN_DANGER("[src] emits a horrifying wail as nearby burrows stir to life!"))
		//Add all nearby burrows to the distressed burrows list

		for (var/obj/structure/burrow/B in find_nearby_burrows())
			B.distress(TRUE)

// If Kaiser slipped on water or soap it would be funncy as hell.
/mob/living/carbon/superior_animal/roach/kaiser/slip(var/slipped_on)
	return FALSE

// TODO: Make him immune for flashes.